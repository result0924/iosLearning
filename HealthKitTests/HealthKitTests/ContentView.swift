//
//  ContentView.swift
//  HealthKitTests
//
//  Created by Justin Lai on 2024/8/20.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    @State private var bloodGlucose: String = ""
    @State private var syncIdentifier: String = ""
    @State private var syncVersion: Int = 1
    @State private var selectedDate = {
        let now = Date()
        let calendar = Calendar.current
        // 將當前時間的秒數設為 0
        return calendar.date(bySetting: .second, value: 0, of: now) ?? now
    }()
    
    let healthStore = HKHealthStore()

    var body: some View {
        VStack {
            TextField("Enter Blood Glucose Value", text: $bloodGlucose)
                .padding()
                .keyboardType(.decimalPad)

            TextField("Enter Sync Identifier", text: $syncIdentifier)
                .padding()

            Stepper("Sync Version: \(syncVersion)", value: $syncVersion, in: 1...100)

            DatePicker("選擇日期時間",
                      selection: $selectedDate,
                      displayedComponents: [.date, .hourAndMinute])
                .padding()

            Button(action: {
                requestAuthorizationAndSave()
            }) {
                Text("Save to Health")
            }
            .padding()
        }
        .padding()
        .onAppear {
            requestAuthorization()
        }
    }

    // 请求授权
    func requestAuthorization() {
        guard let bloodGlucoseType = HKObjectType.quantityType(forIdentifier: .bloodGlucose) else {
            return
        }

        let typesToShare: Set = [bloodGlucoseType]
        let typesToRead: Set = [bloodGlucoseType]

        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            if !success {
                print("Authorization failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    // 保存血糖数据
    func requestAuthorizationAndSave() {
        guard let bloodGlucoseType = HKObjectType.quantityType(forIdentifier: .bloodGlucose) else {
            return
        }

        healthStore.getRequestStatusForAuthorization(toShare: Set([bloodGlucoseType]), read: Set([bloodGlucoseType])) { status, error in
            switch status {
            case .shouldRequest:
                requestAuthorization()
            case .unnecessary:
                saveBloodGlucoseData()
            case .unknown:
                print("Authorization status unknown.")
            @unknown default:
                fatalError()
            }
        }
    }

    func saveBloodGlucoseData() {
        guard let bloodGlucoseValue = Double(bloodGlucose) else {
            print("Invalid blood glucose value")
            return
        }

        let quantityType = HKQuantityType.quantityType(forIdentifier: .bloodGlucose)!
        let quantity = HKQuantity(unit: HKUnit(from: "mg/dL"), doubleValue: bloodGlucoseValue)
        let date = selectedDate

        let metadata: [String: Any] = [
            HKMetadataKeySyncIdentifier: syncIdentifier,
            HKMetadataKeySyncVersion: syncVersion
        ]

        let sample = HKQuantitySample(type: quantityType, quantity: quantity, start: date, end: date, metadata: metadata)

        healthStore.save(sample) { success, error in
            if success {
                print("Blood glucose data saved successfully.")
                // 獲取 UUID
                let uuid = sample.uuid
                print("保存的數據 UUID: \(uuid)")
            } else {
                print("Error saving blood glucose data: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

