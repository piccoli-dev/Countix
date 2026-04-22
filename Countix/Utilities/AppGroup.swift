import Foundation
import UIKit

enum AppGroup {
    static let identifier = "group.com.piccolidev.Countix"
    static let eventsKey = "shared.events"
    static let imagesDirectoryName = "event-backgrounds"

    static func saveEventBackgroundImage(_ imageData: Data, eventID: UUID) -> String? {
        guard let directoryURL = imagesDirectoryURL() else {
            return nil
        }

        let fileName = "\(eventID.uuidString)-\(Int(Date().timeIntervalSince1970)).jpg"
        let fileURL = directoryURL.appendingPathComponent(fileName)
        let jpegData: Data

        if let image = UIImage(data: imageData),
           let compressed = image.jpegData(compressionQuality: 0.78) {
            jpegData = compressed
        } else {
            jpegData = imageData
        }

        do {
            try jpegData.write(to: fileURL, options: [.atomic])
            return fileName
        } catch {
            return nil
        }
    }

    static func loadEventBackgroundImage(fileName: String?) -> UIImage? {
        guard let fileName,
              let directoryURL = imagesDirectoryURL() else {
            return nil
        }

        let fileURL = directoryURL.appendingPathComponent(fileName)
        guard let data = try? Data(contentsOf: fileURL) else {
            return nil
        }

        return UIImage(data: data)
    }

    static func loadEventBackgroundImageData(fileName: String?) -> Data? {
        guard let fileName,
              let directoryURL = imagesDirectoryURL() else {
            return nil
        }

        let fileURL = directoryURL.appendingPathComponent(fileName)
        return try? Data(contentsOf: fileURL)
    }

    static func deleteEventBackgroundImage(fileName: String?) {
        guard let fileName,
              let directoryURL = imagesDirectoryURL() else {
            return
        }

        let fileURL = directoryURL.appendingPathComponent(fileName)
        try? FileManager.default.removeItem(at: fileURL)
    }

    private static func imagesDirectoryURL() -> URL? {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: identifier) else {
            return nil
        }

        let directoryURL = containerURL.appendingPathComponent(imagesDirectoryName, isDirectory: true)

        do {
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            return directoryURL
        } catch {
            return nil
        }
    }
}
