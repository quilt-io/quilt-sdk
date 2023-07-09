//
//  File.swift
//  
//
//  Created by Jessica Petrochuk on 7/8/23.
//

import Foundation
import HealthKit

// TODO: switch so there is a choice when there are multiple options such as inches vs centimeters
// TODO: create a test that ensures all of these units work
@available(macOS 13, *)
public func getUnit(quantityType: HKQuantityType) -> HKUnit? {
    switch quantityType {
        
        // Count data
        case
            HKSampleType.quantityType(forIdentifier: .stepCount)!, // A quantity sample type that measures the number of steps the user has taken.
            HKSampleType.quantityType(forIdentifier: .pushCount)!, // A quantity sample type that measures the number of pushes that the user has performed while using a wheelchair.
            HKSampleType.quantityType(forIdentifier: .swimmingStrokeCount)!, // A quantity sample type that measures the number of strokes performed while swimming.
            HKSampleType.quantityType(forIdentifier: .flightsClimbed)!, // A quantity sample type that measures the number flights of stairs that the user has climbed.
            HKSampleType.quantityType(forIdentifier: .nikeFuel)!, // A quantity sample type that measures the number of NikeFuel points the user has earned.
            HKSampleType.quantityType(forIdentifier: .bodyMassIndex)!, // A quantity sample type that measures the user’s body mass index.
            HKSampleType.quantityType(forIdentifier: .heartRateRecoveryOneMinute)!, // A quantity sample that records the reduction in heart rate from the peak exercise rate to the rate one minute after exercising ended.
            HKSampleType.quantityType(forIdentifier: .numberOfAlcoholicBeverages)!, // A quantity sample type that measures the number of standard alcoholic drinks that the user has consumed.
            HKSampleType.quantityType(forIdentifier: .numberOfTimesFallen)!, // A quantity sample type that measures the number of times the user fell.
            HKSampleType.quantityType(forIdentifier: .uvExposure)!: // A quantity sample type that measures the user’s exposure to UV radiation.
            return .count()
        
        // Count / time data minutes
        case
            HKSampleType.quantityType(forIdentifier: .heartRate)!, // A quantity sample type that measures the user’s heart rate.
            HKSampleType.quantityType(forIdentifier: .restingHeartRate)!, // A quantity sample type that measures the user’s resting heart rate.
            HKSampleType.quantityType(forIdentifier: .walkingHeartRateAverage)!, // A quantity sample type that measures the user’s heart rate while walking.
            HKSampleType.quantityType(forIdentifier: .respiratoryRate)!: // A quantity sample type that measures the user’s respiratory rate.
            return .count().unitDivided(by: .minute())
        
        // Length data (cm)
        case
            HKSampleType.quantityType(forIdentifier: .runningStrideLength)!, // A quantity sample type that measures the distance covered by a single step while running.
            HKSampleType.quantityType(forIdentifier: .runningVerticalOscillation)!, // A quantity sample type measuring pelvis vertical range of motion during a single running stride.
            HKSampleType.quantityType(forIdentifier: .height)!, // A quantity sample type that measures the user’s height.
            HKSampleType.quantityType(forIdentifier: .waistCircumference)!: // A quantity sample type that measures the user’s waist circumference.
            return .meterUnit(with: .centi)
        
        // Length data (m)
        case
            HKSampleType.quantityType(forIdentifier: .sixMinuteWalkTestDistance)!, // A quantity sample type that stores the distance a user can walk during a six-minute walk test.
            HKSampleType.quantityType(forIdentifier: .walkingStepLength)!, // A quantity sample type that measures the average length of the user’s step when walking steadily over flat ground.
            HKSampleType.quantityType(forIdentifier: .underwaterDepth)!: // A quantity sample that records a person’s depth underwater.
            return .meter()
        
        // Length data (km)
        case
            HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!, // A quantity sample type that measures the distance the user has moved by walking or running.
            HKSampleType.quantityType(forIdentifier: .distanceCycling)!, // A quantity sample type that measures the distance the user has moved by cycling.
            HKSampleType.quantityType(forIdentifier: .distanceWheelchair)!, // A quantity sample type that measures the distance the user has moved using a wheelchair.
            HKSampleType.quantityType(forIdentifier: .distanceSwimming)!, // A quantity sample type that measures the distance the user has moved while swimming.
            HKSampleType.quantityType(forIdentifier: .distanceDownhillSnowSports)!: // A quantity sample type that measures the distance the user has traveled while skiing or snowboarding.
            return .meterUnit(with: .kilo)
        
        // Length per time data (m/s)
        case
            HKSampleType.quantityType(forIdentifier: .walkingSpeed)!, // A quantity sample type that measures the user’s average speed when walking steadily over flat ground.
            HKSampleType.quantityType(forIdentifier: .stairAscentSpeed)!, // A quantity sample type measuring the user’s speed while climbing a flight of stairs.
            HKSampleType.quantityType(forIdentifier: .stairDescentSpeed)!: // A quantity sample type measuring the user’s speed while descending a flight of stairs.
            return .meter().unitDivided(by: HKUnit.second())
        
        // Length per time data (km/h)
        case
            HKSampleType.quantityType(forIdentifier: .runningSpeed)!: // A quantity sample type that measures the runner’s speed.
            return .meterUnit(with: .kilo).unitDivided(by: .hour())
        
        // Power units data (W)
        case
            HKSampleType.quantityType(forIdentifier: .runningPower)!: // A quantity sample type that measures the rate of work required for the runner to maintain their speed.
            return .watt()
        
        // Percentage data
        case
            HKSampleType.quantityType(forIdentifier: .bodyFatPercentage)!, // A quantity sample type that measures the user’s body fat percentage.
            HKSampleType.quantityType(forIdentifier: .atrialFibrillationBurden)!, // A quantity type that measures an estimate of the percentage of time a person’s heart shows signs of atrial fibrillation (AFib) while wearing Apple Watch.
            HKSampleType.quantityType(forIdentifier: .oxygenSaturation)!, // A quantity sample type that measures the user’s oxygen saturation.
            HKSampleType.quantityType(forIdentifier: .bloodAlcoholContent)!, // A quantity sample type that measures the user’s blood alcohol content.
            HKSampleType.quantityType(forIdentifier: .appleWalkingSteadiness)!, // A quantity sample type that measures the steadiness of the user’s gait.
            HKSampleType.quantityType(forIdentifier: .walkingAsymmetryPercentage)!, // A quantity sample type that measures the percentage of steps in which one foot moves at a different speed than the other when walking on flat ground.
            HKSampleType.quantityType(forIdentifier: .walkingDoubleSupportPercentage)!, // A quantity sample type that measures the percentage of time when both of the user’s feet touch the ground while walking steadily over flat ground.
            HKSampleType.quantityType(forIdentifier: .peripheralPerfusionIndex)!: // A quantity sample type that measures the user’s peripheral perfusion index.
            return .percent()
        
        // Time data (ms)
        case
            HKSampleType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!: // A quantity sample type that measures the standard deviation of heartbeat intervals.
            return .secondUnit(with: .milli)
        
        // Time data (s)
        case
            HKSampleType.quantityType(forIdentifier: .runningGroundContactTime)!: // A quantity sample type that measures the amount of time the runner’s foot is in contact with the ground while running.
            return .second()
        
        // Time data (min)
        case
            HKSampleType.quantityType(forIdentifier: .appleExerciseTime)!, // A quantity sample type that measures the amount of time the user spent exercising.
            HKSampleType.quantityType(forIdentifier: .appleMoveTime)!: // A quantity sample type that measures the amount of time the user has spent performing activities that involve full-body movements during the specified day.
            return .minute()
        
        // Time data (h)
        case
            HKSampleType.quantityType(forIdentifier: .appleStandTime)!, // A category sample type that counts the number of hours in the day during which the user has stood and moved for at least one minute per hour.
            HKSampleType.quantityType(forIdentifier: .appleStandTime)!: // A quantity sample type that measures the amount of time the user has spent standing.
            return .hour()
        
        // Volume data (mL)
        case
            HKSampleType.quantityType(forIdentifier: .dietaryWater)!: // A quantity sample type that measures the amount of water consumed.
            return .literUnit(with: .milli)
        
        // Volume data (L)
        case
            HKSampleType.quantityType(forIdentifier: .forcedExpiratoryVolume1)!, // A quantity sample type that measures the amount of air that can be forcibly exhaled from the lungs during the first second of a forced exhalation.
            HKSampleType.quantityType(forIdentifier: .forcedVitalCapacity)!: // A quantity sample type that measures the amount of air that can be forcibly exhaled from the lungs after taking the deepest breath possible.
            return .liter()
        
        // Volume per time data (L/min)
        case
            HKSampleType.quantityType(forIdentifier: .peakExpiratoryFlowRate)!: // A quantity sample type that measures the user’s maximum flow rate generated during a forceful exhalation.
            return .liter().unitDivided(by: .minute())
        
        // Volume per mass per time data
        case
            HKSampleType.quantityType(forIdentifier: .vo2Max)!: // A quantity sample that measures the maximal oxygen consumption during exercise.
            return .literUnit(with: .milli).unitDivided(by: .gramUnit(with: .kilo).unitMultiplied(by: .minute())) // TODO: Check this
        
        // Temperature data (C)
        case
            HKSampleType.quantityType(forIdentifier: .appleSleepingWristTemperature)!, // A quantity sample type that records the wrist temperature during sleep.
            HKSampleType.quantityType(forIdentifier: .basalBodyTemperature)!, // A quantity sample type that records the user’s basal body temperature
            HKSampleType.quantityType(forIdentifier: .bodyTemperature)!, // A quantity sample type that measures the user’s body temperature.
            HKSampleType.quantityType(forIdentifier: .waterTemperature)!: // A quantity sample that records the water temperature.
            return .degreeCelsius()
        
        // Energy data (kcal)
        case
            HKSampleType.quantityType(forIdentifier: .basalEnergyBurned)!, // A quantity sample type that measures the resting energy burned by the user.
            HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!, // A quantity sample type that measures the amount of active energy the user has burned.
            HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!: // A quantity sample type that measures the amount of energy consumed.
            return .kilocalorie()
            
        // Sounds pressure data
        case
            HKSampleType.quantityType(forIdentifier: .environmentalAudioExposure)!, // A quantity sample type that measures audio exposure to sounds in the environment.
            HKSampleType.quantityType(forIdentifier: .headphoneAudioExposure)!: // A quantity sample type that measures audio exposure from headphones.
            return .decibelAWeightedSoundPressureLevel()
        
        // Pressure data (mmgh)
        case
            HKSampleType.quantityType(forIdentifier: .bloodPressureSystolic)!, // A quantity sample type that measures the user’s systolic blood pressure.
            HKSampleType.quantityType(forIdentifier: .bloodPressureDiastolic)!: // A quantity sample type that measures the user’s diastolic blood pressure.
            return .millimeterOfMercury()
        
        // Mass data (mg)
        case
            HKSampleType.quantityType(forIdentifier: .dietaryCholesterol)!, // A quantity sample type that measures the amount of cholesterol consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryVitaminA)!, // A quantity sample type that measures the amount of vitamin A consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryThiamin)!, // A quantity sample type that measures the amount of thiamin (vitamin B1) consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryRiboflavin)!, // A quantity sample type that measures the amount of riboflavin (vitamin B2) consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryNiacin)!, // A quantity sample type that measures the amount of niacin (vitamin B3) consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryPantothenicAcid)!, // A quantity sample type that measures the amount of pantothenic acid (vitamin B5) consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryVitaminB6)!, // A quantity sample type that measures the amount of pyridoxine (vitamin B6) consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryBiotin)!, // A quantity sample type that measures the amount of biotin (vitamin B7) consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryVitaminB12)!, // A quantity sample type that measures the amount of cyanocobalamin (vitamin B12) consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryVitaminC)!, // A quantity sample type that measures the amount of vitamin C consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryVitaminD)!, // A quantity sample type that measures the amount of vitamin D consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryVitaminE)!, // A quantity sample type that measures the amount of vitamin E consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryVitaminK)!, // A quantity sample type that measures the amount of vitamin K consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryFolate)!, // A quantity sample type that measures the amount of folate (folic acid) consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryCalcium)!, // A quantity sample type that measures the amount of calcium consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryChloride)!, // A quantity sample type that measures the amount of chloride consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryIron)!, // A quantity sample type that measures the amount of iron consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryMagnesium)!, // A quantity sample type that measures the amount of magnesium consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryPhosphorus)!, // A quantity sample type that measures the amount of phosphorus consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryPotassium)!, // A quantity sample type that measures the amount of potassium consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryZinc)!, // A quantity sample type that measures the amount of zinc consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryCaffeine)!, // A quantity sample type that measures the amount of caffeine consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryChromium)!, // A quantity sample type that measures the amount of chromium consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryCopper)!, // A quantity sample type that measures the amount of copper consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryIodine)!, // A quantity sample type that measures the amount of iodine consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryManganese)!, // A quantity sample type that measures the amount of manganese consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryMolybdenum)!, // A quantity sample type that measures the amount of molybdenum consumed.
            HKSampleType.quantityType(forIdentifier: .dietarySelenium)!: // A quantity sample type that measures the amount of selenium consumed.
            return .gramUnit(with: .milli)
        
        // Mass data (g)
        case
            HKSampleType.quantityType(forIdentifier: .dietaryCarbohydrates)!, // A quantity sample type that measures the amount of carbohydrates consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryFiber)!, // A quantity sample type that measures the amount of fiber consumed.
            HKSampleType.quantityType(forIdentifier: .dietarySugar)!, // A quantity sample type that measures the amount of sugar consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryFatTotal)!, // A quantity sample type that measures the total amount of fat consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryFatMonounsaturated)!, // A quantity sample type that measures the amount of monounsaturated fat consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryFatPolyunsaturated)!, // A quantity sample type that measures the amount of polyunsaturated fat consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryFatSaturated)!, // A quantity sample type that measures the amount of saturated fat consumed.
            HKSampleType.quantityType(forIdentifier: .dietaryProtein)!, // A quantity sample type that measures the amount of protein consumed.
            HKSampleType.quantityType(forIdentifier: .dietarySodium)!: // A quantity sample type that measures the amount of sodium consumed.
            return .gramUnit(with: .none)

        // Mass data (kg)
        case
            HKSampleType.quantityType(forIdentifier: .bodyMass)!, // A quantity sample type that measures the user’s weight.
            HKSampleType.quantityType(forIdentifier: .leanBodyMass)!: // A quantity sample type that measures the user’s lean body mass.
            return .gramUnit(with: .kilo)
        
        // Mass per volume data (mg/dL)
        case
            HKSampleType.quantityType(forIdentifier: .bloodGlucose)!: // A quantity sample type that measures the user’s blood glucose level.
            return .gramUnit(with: .milli).unitDivided(by: .literUnit(with: .deci))
        
        // Conductance data
        case
            HKSampleType.quantityType(forIdentifier: .electrodermalActivity)!: // A quantity sample type that measures electrodermal activity.
            return .siemen()
        
        // International unit data
        case
            HKSampleType.quantityType(forIdentifier: .insulinDelivery)!: // A quantity sample that measures the amount of insulin delivered.
            return .internationalUnit()
            
        default:
            fatalError("Type not supported)")
        }
}
