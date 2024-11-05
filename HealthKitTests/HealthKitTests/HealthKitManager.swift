import HealthKit

class HealthKitManager {
    static let shared = HealthKitManager()
    let healthStore = HKHealthStore()
    
    func deleteBloodGlucoseData(value: String, date: Date, syncIdentifier: String? = nil, completion: (() -> Void)? = nil) {
        guard let bloodGlucoseValue = Double(value) else {
            print("Invalid blood glucose value")
            return
        }
        
        let quantityType = HKQuantityType.quantityType(forIdentifier: .bloodGlucose)!
        let quantity = HKQuantity(unit: HKUnit(from: "mg/dL"), doubleValue: bloodGlucoseValue)
        
        // 創建查詢條件
        var predicates: [NSPredicate] = []
        
        // 時間範圍條件（精確到分鐘）
        let calendar = Calendar.current
        let startDate = calendar.date(bySettingHour: calendar.component(.hour, from: date),
                                    minute: calendar.component(.minute, from: date),
                                    second: 0,
                                    of: date)!
        let endDate = calendar.date(bySettingHour: calendar.component(.hour, from: date),
                                  minute: calendar.component(.minute, from: date),
                                  second: 59,
                                  of: date)!
        predicates.append(HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate))
        
        // 血糖值條件
        predicates.append(HKQuery.predicateForQuantitySamples(with: .equalTo, quantity: quantity))
        
        // 如果有 syncIdentifier，添加同步標識條件
        if let syncId = syncIdentifier, !syncId.isEmpty {
            predicates.append(HKQuery.predicateForObjects(withMetadataKey: HKMetadataKeySyncIdentifier,
                                                        allowedValues: [syncId]))
        }
        
        // 組合所有條件
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        let query = HKSampleQuery(sampleType: quantityType,
                                predicate: compoundPredicate,
                                limit: HKObjectQueryNoLimit,
                                sortDescriptors: nil) { (query, samples, error) in
            guard let samplesToDelete = samples else {
                print("No samples found to delete")
                completion?()
                return
            }
            
            self.healthStore.delete(samplesToDelete) { (success, error) in
                if success {
                    print("Successfully deleted \(samplesToDelete.count) samples")
                } else {
                    print("Error deleting samples: \(error?.localizedDescription ?? "Unknown error")")
                }
                completion?()
            }
        }
        
        healthStore.execute(query)
    }
} 
