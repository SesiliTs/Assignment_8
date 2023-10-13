
//4-StationModule-ი
//With properties: moduleName: String და drone: Drone? (optional).
//Method რომელიც დრონს მისცემს თასქს.


//5-ჩვენი ControlCenter-ი ResearchLab-ი და LifeSupportSystem-ა გავხადოთ StationModule-ის subClass.

class StationModule {
    let moduleName: String
    var drone: Drone?
    
    init(moduleName: String) {
        self.moduleName = moduleName
    }
    
    fileprivate func assignTask(drone: Drone, task: String) {
        drone.task = task
    }
}

//1-ControlCenter-ი.
//With properties: isLockedDown: Bool და securityCode: String, რომელშიც იქნება რაღაც პაროლი შენახული.
//Method lockdown, რომელიც მიიღებს პაროლს, ჩვენ დავადარებთ ამ პაროლს securityCode-ს და თუ დაემთხვა გავაკეთებთ lockdown-ს.
//Method-ი რომელიც დაგვიბეჭდავს ინფორმაციას lockdown-ის ქვეშ ხომ არაა ჩვენი ControlCenter-ი.

class ControlCenter: StationModule {
    private var isLockedDown: Bool
    private var securityCode: String = "VeryStrongPassword!"
    
    init(isLockedDown: Bool, moduleName: String, drone: Drone) {
        self.isLockedDown = isLockedDown
        super.init(moduleName: moduleName)
    }
    
    func lockdown(password: String) {
        if password == securityCode {
            isLockedDown = true
        }
    }
    
    func isCenterLockedDown() {
        print(isLockedDown == true ? "ControlCenter is locked down" : "ControlCenter is not locked")
    }
}


//2-ResearchLab-ი.
//With properties: String Array - ნიმუშების შესანახად.
//Method რომელიც მოიპოვებს(დაამატებს) ნიმუშებს ჩვენს Array-ში.


class ResearchLab: StationModule {
    private var samples: [String]
    
    init(samples: [String], moduleName: String, drone: Drone) {
        self.samples = samples
        super.init(moduleName: moduleName)
    }
    
    func addNewSample(sample: String) {
        samples.append(sample)
    }
}


//3-LifeSupportSystem-ა.
//With properties: oxygenLevel: Int, რომელიც გააკონტროლებს ჟანგბადის დონეს.
//Method რომელიც გვეტყვის ჟანგბადის სტატუსზე.


class LifeSupportSystem: StationModule {
    var oxygenLevel: Int
    
    init(oxygenLevel: Int, moduleName: String, drone: Drone) {
        self.oxygenLevel = oxygenLevel
        super.init(moduleName: moduleName)
    }
    
    func oxygenStatus() {
        print("Oxygen level is:", oxygenLevel)
    }
}


//6-Drone.
//With properties: task: String? (optional), unowned var assignedModule: StationModule, weak var missionControlLink: MissionControl? (optional).
//Method რომელიც შეამოწმებს აქვს თუ არა დრონს თასქი და თუ აქვს დაგვიბჭდავს რა სამუშაოს ასრულებს ის.

class Drone {
    var task: String?
    unowned var assignedModule: StationModule
    weak var missionControlLink: MissionControl?
    
    init(assignedModule: StationModule) {
        self.assignedModule = assignedModule
    }
    
    func doesDroneHaveTask() {
        if let task {
            print("Current task for the drone:", task)
        } else {
            print("Drone has no task")
        }
    }
}


//7-OrbitronSpaceStation-ი შევქმნათ, შიგნით ავაწყოთ ჩვენი მოდულები ControlCenter-ი, ResearchLab-ი და LifeSupportSystem-ა. ასევე ამ მოდულებისთვის გავაკეთოთ თითო დრონი და მივაწოდოთ ამ მოდულებს რათა მათ გამოყენება შეძლონ.
//ასევე ჩვენს OrbitronSpaceStation-ს შევუქმნათ ფუნქციონალი lockdown-ის რომელიც საჭიროების შემთხვევაში controlCenter-ს დალოქავს.


let controlCenterModule = StationModule(moduleName: "controlCenterModule")
let controlCenterDrone = Drone(assignedModule: controlCenterModule)
let researchLabModule = StationModule(moduleName: "researchLabModule")
let researchLabDrone = Drone(assignedModule: researchLabModule)
let lifeSupportModule = StationModule(moduleName: "lifeSupportModule")
let lifeSupportDrone = Drone(assignedModule: lifeSupportModule)

class OrbitronSpaceStation {
    
    let controlCenter = ControlCenter(isLockedDown: false, moduleName: "controlCenterModule", drone: controlCenterDrone)
    let researchLab = ResearchLab(samples: ["sample3", "Sample2"], moduleName: "researchLabModule", drone: researchLabDrone)
    let lifeSupportSystem = LifeSupportSystem(oxygenLevel: 85, moduleName: "lifeSupportModule", drone: lifeSupportDrone)
    
    func lockControlCenterDown(password: String) {
        controlCenter.lockdown(password: password)
    }
}

//8-MissionControl.
//With properties: spaceStation: OrbitronSpaceStation? (optional).
//Method რომ დაუკავშირდეს OrbitronSpaceStation-ს და დაამყაროს მასთან კავშირი.
//Method requestControlCenterStatus-ი.
//Method requestOxygenStatus-ი.
//Method requestDroneStatus რომელიც გაარკვევს რას აკეთებს კონკრეტული მოდულის დრონი.

class MissionControl {
    var spaceStation: OrbitronSpaceStation?
    
    func connectOrbitron(station: OrbitronSpaceStation) {
        spaceStation = station
    }
    func requestControlCenterStatus(controlCenter: ControlCenter) {
        controlCenter.isCenterLockedDown()
    }
    func requestOxygenStatus(lifeSupportSystem: LifeSupportSystem) {
        lifeSupportSystem.oxygenStatus()
    }
    func requestDroneStatus(drone: Drone) {
        drone.doesDroneHaveTask()
    }
}


//9-და ბოლოს
//შევქმნათ OrbitronSpaceStation,

let orbitronSpaceStation = OrbitronSpaceStation()

//შევქმნათ MissionControl-ი,

let missionControl = MissionControl()

//missionControl-ი დავაკავშიროთ OrbitronSpaceStation სისტემასთან,

missionControl.connectOrbitron(station: orbitronSpaceStation)

//როცა კავშირი შედგება missionControl-ით მოვითხოვოთ controlCenter-ის status-ი.

missionControl.requestControlCenterStatus(controlCenter: orbitronSpaceStation.controlCenter)

//controlCenter-ის, researchLab-ის და lifeSupport-ის მოდულების დრონებს დავურიგოთ თასქები.
//შევამოწმოთ დრონების სტატუსები.
//შევამოწმოთ ჟანგბადის რაოდენობა.
//შევამოწმოთ ლოქდაუნის ფუნქციონალი და შევამოწმოთ დაილოქა თუ არა ხომალდი სწორი პაროლი შევიყვანეთ თუ არა.

controlCenterModule.assignTask(drone: controlCenterDrone, task: "fix the engine")
researchLabModule.assignTask(drone: researchLabDrone, task: "look for the new samples")
lifeSupportModule.assignTask(drone: lifeSupportDrone, task: "check oxygen lever regularly")

missionControl.requestDroneStatus(drone: controlCenterDrone)
missionControl.requestDroneStatus(drone: researchLabDrone)
missionControl.requestDroneStatus(drone: lifeSupportDrone)

missionControl.requestOxygenStatus(lifeSupportSystem: orbitronSpaceStation.lifeSupportSystem)
orbitronSpaceStation.lockControlCenterDown(password: "VeryStrongPassword!")
missionControl.requestControlCenterStatus(controlCenter: orbitronSpaceStation.controlCenter)


//10- გამოიყენეთ access levels სადაც საჭიროა (ცვლადებთან და მეთოდებთან).
