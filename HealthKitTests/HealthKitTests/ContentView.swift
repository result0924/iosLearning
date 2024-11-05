//
//  ContentView.swift
//  HealthKitTests
//
//  Created by Justin Lai on 2024/8/20.
//

import SwiftUI
import HealthKit

struct KeyboardAdaptive: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .padding(.bottom, keyboardHeight)
                .animation(.easeOut(duration: 0.16), value: keyboardHeight)
                .frame(height: geometry.size.height - keyboardHeight)
                .onAppear {
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
                        keyboardHeight = keyboardFrame.height + 49
                    }
                    
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                        keyboardHeight = 0
                    }
                }
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            SyncDataView()
                .tabItem {
                    Image(systemName: "arrow.triangle.2.circlepath")
                    Text("同步模式")
                }
            
            SimpleDataView()
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("簡單模式")
                }
        }
    }
}

struct SyncDataView: View {
    @State private var bloodGlucose: String = ""
    @State private var syncIdentifier: String = ""
    @State private var syncVersion: Int = 1
    @State private var selectedDate = {
        let now = Date()
        let calendar = Calendar.current
        return calendar.date(bySetting: .second, value: 0, of: now) ?? now
    }()
    
    @FocusState private var isFocused: Bool
    
    let healthStore = HKHealthStore()
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Enter Blood Glucose Value", text: $bloodGlucose)
                .padding()
                .keyboardType(.decimalPad)
                .focused($isFocused)
            
            TextField("Enter Sync Identifier", text: $syncIdentifier)
                .padding()
                .focused($isFocused)
            
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
            
            Button(action: {
                deleteBloodGlucoseData()
            }) {
                Text("Delete Data")
                    .foregroundColor(.red)
            }
            .padding()
            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isFocused = false
                }
            }
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
                let uuid = sample.uuid
                print("保存的數據 UUID: \(uuid)")
            } else {
                print("Error saving blood glucose data: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    // 添加刪除方法
    func deleteBloodGlucoseData() {
        HealthKitManager.shared.deleteBloodGlucoseData(
            value: bloodGlucose,
            date: selectedDate,
            syncIdentifier: syncIdentifier
        )
    }
}

struct SimpleDataView: View {
    @State private var bloodGlucose: String = ""
    @State private var selectedDate = {
        let now = Date()
        let calendar = Calendar.current
        return calendar.date(bySetting: .second, value: 0, of: now) ?? now
    }()
    
    @FocusState private var isFocused: Bool
    
    let healthStore = HKHealthStore()
    
    var body: some View {
        VStack {
            TextField("Enter Blood Glucose Value", text: $bloodGlucose)
                .padding()
                .keyboardType(.decimalPad)
                .focused($isFocused)
            
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
            
            Button(action: {
                deleteBloodGlucoseData()
            }) {
                Text("Delete Data")
                    .foregroundColor(.red)
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isFocused = false
                }
            }
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
        
        let sample = HKQuantitySample(type: quantityType, quantity: quantity, start: date, end: date)
        
        healthStore.save(sample) { success, error in
            if success {
                print("Blood glucose data saved successfully.")
                let uuid = sample.uuid
                print("保存的數據 UUID: \(uuid)")
            } else {
                print("Error saving blood glucose data: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    // 添加刪除方法
    func deleteBloodGlucoseData() {
        HealthKitManager.shared.deleteBloodGlucoseData(
            value: bloodGlucose,
            date: selectedDate
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

