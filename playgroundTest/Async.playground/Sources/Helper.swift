import Foundation

public func printElapsedTime(from startTime: Date) {
    let endTime = Date.now
    let timePassed = (startTime.distance(to: endTime)).formatted()
    print("完成任務時間經過：\(timePassed) 秒")
}

extension Task where Success == Never, Failure == Never {
    public static func sleep(seconds: Double) async throws {
        let nanoseconds = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: nanoseconds)
    }
}
