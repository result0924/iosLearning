//
//  ContentView.swift
//  HealthKitTests
//
//  Created by Justin Lai on 2024/8/20.
//

import SwiftUI
import HealthKit

let healthStore = HKHealthStore()

struct HealthData: Identifiable {
    let id = UUID()
    var type: String
    var value: String
    var value2: String?
    var date: Date
    var syncIdentifier: String
    var syncVersion: String
}

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
    @State private var healthDataList: [HealthData] = [
        HealthData(type: "血糖", value: "", value2: nil, date: Date(), syncIdentifier: "", syncVersion: ""),
        HealthData(type: "血壓", value: "", value2: "", date: Date(), syncIdentifier: "", syncVersion: ""),
        HealthData(type: "心跳", value: "", value2: nil, date: Date(), syncIdentifier: "", syncVersion: ""),
        HealthData(type: "體重", value: "", value2: nil, date: Date(), syncIdentifier: "", syncVersion: ""),
        HealthData(type: "體脂", value: "", value2: nil, date: Date(), syncIdentifier: "", syncVersion: "")
    ]
    
    init() {
        // 請求需要的權限
        let typesToShare: Set = [
            HKObjectType.quantityType(forIdentifier: .bloodGlucose)!,
            HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic)!,
            HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
            HKObjectType.quantityType(forIdentifier: .bodyFatPercentage)!
        ]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToShare) { (success, error) in
            if !success {
                print("請求 HealthKit 權限失敗: \(error?.localizedDescription ?? "未知錯誤")")
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List(healthDataList) { data in
                NavigationLink(destination: HealthDataEditView(healthData: binding(for: data))) {
                    HStack {
                        Text(data.type)
                        Spacer()
                        if !data.value.isEmpty {
                            if data.type == "血壓" {
                                Text("\(data.value)/\(data.value2 ?? "")")
                                    .foregroundColor(.gray)
                            } else {
                                Text(data.value)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("健康數據")
        }
    }
    
    private func binding(for data: HealthData) -> Binding<HealthData> {
        Binding(
            get: { data },
            set: { newValue in
                if let index = healthDataList.firstIndex(where: { $0.id == newValue.id }) {
                    healthDataList[index] = newValue
                }
            }
        )
    }
}

// 添加一個擴展來處理列表標題
extension View {
    func listSectionHeader(_ text: String) -> some View {
        Section(header: Text(text)) {
            self
        }
    }
}

struct HealthDataEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var healthData: HealthData
    @State private var showingSaveAlert = false
    @State private var alertMessage = ""
    @State private var heartRate: String = ""  // 新增心跳數值
    
    var body: some View {
        List {
            Group {
                if healthData.type == "血壓" {
                    VStack(spacing: 10) {
                        HStack {
                            Text("收縮壓:")
                                .frame(width: 70, alignment: .leading)
                            TextField("收縮壓", text: $healthData.value)
                                .keyboardType(.decimalPad)
                            Text("mmHg")
                        }
                        HStack {
                            Text("舒張壓:")
                                .frame(width: 70, alignment: .leading)
                            TextField("舒張壓", text: Binding(
                                get: { healthData.value2 ?? "" },
                                set: { healthData.value2 = $0 }
                            ))
                            .keyboardType(.decimalPad)
                            Text("mmHg")
                        }
                    }
                } else if healthData.type == "心跳" {
                    HStack {
                        Text("心跳:")
                            .frame(width: 60, alignment: .leading)
                        TextField("心跳數值", text: $healthData.value)
                            .keyboardType(.decimalPad)
                        Text("次/分")
                    }
                } else {
                    TextField("輸入\(healthData.type)數值", text: $healthData.value)
                        .keyboardType(.decimalPad)
                }
            }
            .listSectionHeader("數值")
            
            Group {
                DatePicker("選擇時間", selection: $healthData.date)
                    .datePickerStyle(.compact)
            }
            .listSectionHeader("時間")
            
            Group {
                TextField("同步 ID", text: $healthData.syncIdentifier)
                TextField("同步版本", text: $healthData.syncVersion)
            }
            .listSectionHeader("同步資訊")
            
            Button(action: saveToHealthKit) {
                HStack {
                    Spacer()
                    Text("保存到健康")
                    Spacer()
                }
            }
            .foregroundColor(.blue)
        }
        .navigationTitle(healthData.type)
        .alert(
            "保存結果",
            isPresented: $showingSaveAlert,
            actions: {
                Button("確定") {
                    if alertMessage.contains("成功") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            },
            message: {
                Text(alertMessage)
            }
        )
    }
    
    private func saveToHealthKit() {
        if healthData.type == "血壓" {
            // 檢查血壓數值
            let hasSystolic = !healthData.value.isEmpty
            let hasDiastolic = !(healthData.value2 ?? "").isEmpty
            
            if hasSystolic != hasDiastolic {
                alertMessage = "請同時填寫收縮壓和舒張壓"
                showingSaveAlert = true
                return
            }
            
            if hasSystolic && hasDiastolic {
                if let systolic = Double(healthData.value),
                   let diastolic = Double(healthData.value2 ?? "") {
                    saveBloodPressure(systolic, diastolic: diastolic) { success in
                        DispatchQueue.main.async {
                            if success {
                                alertMessage = "血壓數據保存成功"
                            } else {
                                alertMessage = "血壓數據保存失敗"
                            }
                            showingSaveAlert = true
                        }
                    }
                } else {
                    alertMessage = "請輸入有效的血壓數值"
                    showingSaveAlert = true
                }
            }
        } else if healthData.type == "心跳" {
            if let heartRateValue = Double(healthData.value) {
                saveHeartRate(heartRateValue) { success in
                    DispatchQueue.main.async {
                        if success {
                            alertMessage = "心跳數據保存成功"
                        } else {
                            alertMessage = "心跳數據保存失敗"
                        }
                        showingSaveAlert = true
                    }
                }
            } else {
                alertMessage = "請輸入有效的心跳數值"
                showingSaveAlert = true
            }
        } else if healthData.type == "血糖" {
            if let value = Double(healthData.value) {
                saveBloodGlucose(value)
            } else {
                alertMessage = "請輸入有效的數值"
                showingSaveAlert = true
            }
        } else if healthData.type == "體重" {
            if let value = Double(healthData.value) {
                saveWeight(value)
            } else {
                alertMessage = "請輸入有效的數值"
                showingSaveAlert = true
            }
        } else if healthData.type == "體脂" {
            if let value = Double(healthData.value) {
                saveBodyFat(value)
            } else {
                alertMessage = "請輸入有效的數值"
                showingSaveAlert = true
            }
        }
    }
    
    private func normalizeDate(_ date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        return calendar.date(from: components) ?? date
    }
    
    private func saveBloodPressure(_ systolic: Double, diastolic: Double, completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            alertMessage = "HealthKit 不可用"
            showingSaveAlert = true
            completion(false)
            return
        }
        
        let systolicType = HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic)!
        let diastolicType = HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic)!
        let pressureUnit = HKUnit.millimeterOfMercury()
        
        var metadata: [String: Any] = [:]
        if !healthData.syncIdentifier.isEmpty {
            metadata[HKMetadataKeySyncIdentifier] = healthData.syncIdentifier
        }
        if !healthData.syncVersion.isEmpty {
            if let versionNumber = Int(healthData.syncVersion) {
                metadata[HKMetadataKeySyncVersion] = NSNumber(value: versionNumber)
            }
        }
        
        let normalizedDate = normalizeDate(healthData.date)
        
        // 創建收縮壓樣本
        let systolicQuantity = HKQuantity(unit: pressureUnit, doubleValue: systolic)
        let systolicSample = HKQuantitySample(type: systolicType,
                                            quantity: systolicQuantity,
                                            start: normalizedDate,
                                            end: normalizedDate,
                                            metadata: metadata)
        
        // 創建舒張壓樣本
        let diastolicQuantity = HKQuantity(unit: pressureUnit, doubleValue: diastolic)
        let diastolicSample = HKQuantitySample(type: diastolicType,
                                         quantity: diastolicQuantity,
                                         start: normalizedDate,
                                         end: normalizedDate,
                                         metadata: metadata)
        
        // 創建血壓關聯
        let bloodPressureType = HKCorrelationType.correlationType(forIdentifier: .bloodPressure)!
        let correlation = HKCorrelation(type: bloodPressureType,
                                  start: normalizedDate,
                                  end: normalizedDate,
                                  objects: Set([systolicSample, diastolicSample]),
                                  metadata: metadata)
        
        // 保存血壓關聯
        healthStore.save(correlation) { (success, error) in
            DispatchQueue.main.async {
                if !success {
                    alertMessage = "血壓保存失敗: \(error?.localizedDescription ?? "未知錯誤")"
                    showingSaveAlert = true
                }
                completion(success)
            }
        }
    }
    
    private func saveHeartRate(_ value: Double, completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            alertMessage = "HealthKit 不可用"
            showingSaveAlert = true
            completion(false)
            return
        }
        
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let heartRateUnit = HKUnit.count().unitDivided(by: .minute())
        
        var metadata: [String: Any] = [:]
        if !healthData.syncIdentifier.isEmpty {
            metadata[HKMetadataKeySyncIdentifier] = healthData.syncIdentifier
        }
        if !healthData.syncVersion.isEmpty {
            if let versionNumber = Int(healthData.syncVersion) {
                metadata[HKMetadataKeySyncVersion] = NSNumber(value: versionNumber)
            }
        }
        
        let normalizedDate = normalizeDate(healthData.date)
        let heartRateQuantity = HKQuantity(unit: heartRateUnit, doubleValue: value)
        let heartRateSample = HKQuantitySample(type: heartRateType,
                                         quantity: heartRateQuantity,
                                         start: normalizedDate,
                                         end: normalizedDate,
                                         metadata: metadata)
        
        healthStore.save(heartRateSample) { (success, error) in
            DispatchQueue.main.async {
                if !success {
                    alertMessage = "心跳保存失敗: \(error?.localizedDescription ?? "未知錯誤")"
                    showingSaveAlert = true
                }
                completion(success)
            }
        }
    }
    
    private func saveBloodGlucose(_ value: Double) {
        guard HKHealthStore.isHealthDataAvailable() else {
            alertMessage = "HealthKit 不可用"
            showingSaveAlert = true
            return
        }
        
        let glucoseType = HKObjectType.quantityType(forIdentifier: .bloodGlucose)!
        let glucoseUnit = HKUnit.init(from: "mg/dL")
        
        var metadata: [String: Any] = [:]
        if !healthData.syncIdentifier.isEmpty {
            metadata[HKMetadataKeySyncIdentifier] = healthData.syncIdentifier
        }
        if !healthData.syncVersion.isEmpty {
            if let versionNumber = Int(healthData.syncVersion) {
                metadata[HKMetadataKeySyncVersion] = NSNumber(value: versionNumber)
            }
        }
        
        let normalizedDate = normalizeDate(healthData.date)
        let glucoseQuantity = HKQuantity(unit: glucoseUnit, doubleValue: value)
        let glucoseSample = HKQuantitySample(type: glucoseType,
                                           quantity: glucoseQuantity,
                                           start: normalizedDate,
                                           end: normalizedDate,
                                           metadata: metadata)
        
        healthStore.save(glucoseSample) { (success, error) in
            DispatchQueue.main.async {
                if success {
                    alertMessage = "血糖數據保存成功"
                } else {
                    alertMessage = "血糖保存失敗: \(error?.localizedDescription ?? "未知錯誤")"
                }
                showingSaveAlert = true
            }
        }
    }
    
    private func saveWeight(_ value: Double) {
        guard HKHealthStore.isHealthDataAvailable() else {
            alertMessage = "HealthKit 不可用"
            showingSaveAlert = true
            return
        }
        
        let weightType = HKObjectType.quantityType(forIdentifier: .bodyMass)!
        let weightUnit = HKUnit.gramUnit(with: .kilo)
        let weightQuantity = HKQuantity(unit: weightUnit, doubleValue: value)
        
        var metadata: [String: Any] = [:]
        if !healthData.syncIdentifier.isEmpty {
            metadata[HKMetadataKeySyncIdentifier] = healthData.syncIdentifier
        }
        if !healthData.syncVersion.isEmpty {
            if let versionNumber = Int(healthData.syncVersion) {
                metadata[HKMetadataKeySyncVersion] = NSNumber(value: versionNumber)
            }
        }
        
        let normalizedDate = normalizeDate(healthData.date)
        let weightSample = HKQuantitySample(type: weightType,
                                          quantity: weightQuantity,
                                          start: normalizedDate,
                                          end: normalizedDate,
                                          metadata: metadata)
        
        healthStore.save(weightSample) { (success, error) in
            DispatchQueue.main.async {
                if success {
                    alertMessage = "體重數據保存成功"
                } else {
                    alertMessage = "保存失敗: \(error?.localizedDescription ?? "未知錯誤")"
                }
                showingSaveAlert = true
            }
        }
    }
    
    private func saveBodyFat(_ value: Double) {
        guard HKHealthStore.isHealthDataAvailable() else {
            alertMessage = "HealthKit 不可用"
            showingSaveAlert = true
            return
        }
        
        let bodyFatType = HKObjectType.quantityType(forIdentifier: .bodyFatPercentage)!
        let bodyFatUnit = HKUnit.percent()
        let bodyFatQuantity = HKQuantity(unit: bodyFatUnit, doubleValue: value / 100.0)
        
        var metadata: [String: Any] = [:]
        if !healthData.syncIdentifier.isEmpty {
            metadata[HKMetadataKeySyncIdentifier] = healthData.syncIdentifier
        }
        if !healthData.syncVersion.isEmpty {
            if let versionNumber = Int(healthData.syncVersion) {
                metadata[HKMetadataKeySyncVersion] = NSNumber(value: versionNumber)
            }
        }
        
        let normalizedDate = normalizeDate(healthData.date)
        let bodyFatSample = HKQuantitySample(type: bodyFatType,
                                           quantity: bodyFatQuantity,
                                           start: normalizedDate,
                                           end: normalizedDate,
                                           metadata: metadata)
        
        healthStore.save(bodyFatSample) { (success, error) in
            DispatchQueue.main.async {
                if success {
                    alertMessage = "體脂數據保存成功"
                } else {
                    alertMessage = "保存失敗: \(error?.localizedDescription ?? "未知錯誤")"
                }
                showingSaveAlert = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


