// :replace-start: {
//   "terms": {
//     "AnyRealmValueExample_": ""
//   }
// }
import XCTest
import RealmSwift

class AnyRealmValueExample_Dog: Object {
    @objc dynamic var name = ""
    let age = RealmProperty<AnyRealmValue>()
    let companion = RealmProperty<AnyRealmValue>()
}

class AnyRealmValueTestCase: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }

    func testAnyRealmValue() {
        // :code-block-start: mixed-data-type
        // Create a AnyRealmValueExample_Dog object and then set its properties
        let myDog = AnyRealmValueExample_Dog()
        myDog.name = "Rex"
        // Because we declared age as a `RealmProperty`, we must mutate its `value` property
        myDog.age.value = .int(5)
        // This dog has no companion.
        // You can set the field's type to "none", which represents `nil`
        myDog.companion.value = .none

        // Create another AnyRealmValueExample_Dog object whose age is a float
        let myOtherDog = AnyRealmValueExample_Dog()
        myOtherDog.name = "Spot"
        myOtherDog.age.value = .float(2.5)
        // This dog's companion is a cat named Fluffy, represented by a string here
        myOtherDog.companion.value = .string("Fluffy the Cat")

        // Create a third AnyRealmValueExample_Dog object whose age is a string
        let myThirdDog = AnyRealmValueExample_Dog()
        myThirdDog.name = "Fido"
        myThirdDog.age.value = .string("3 months")
        // This dog's companion is a Person, which is an object that has a
        // string name, an optional string address, and an int age
        myThirdDog.companion.value = .object(Person(value: ["name": "Sylvia", "age": 12]))

        // Get the default realm. You only need to do this once per thread.
        let realm = try! Realm()

        // Add to the realm inside a transaction
        try! realm.write {
            realm.add(myDog)
            realm.add(myOtherDog)
            realm.add(myThirdDog)
        }

        // Verify the type of the ``AnyRealmProperty`` when attempting to get it. This
        // returns an object whose property contains the matched type.
        if case let .int(age) = myDog.age.value {
            print(age)  // Prints 5
        }

        // In this example, "myOtherDog"'s age is a float type, so checking the type
        // before trying to use it avoids an exception
        if case let .int(age) = myOtherDog.age.value {
            print(age)  // Doesn't print anything
        }

        // Retreiving an object stored as an ``AnyRealmProperty`` gives you
        // the complete object, containing all of the object's properties
        if case let .object(companion) = myThirdDog.companion.value {
            print(companion)
            // Prints all the details of the Person object:
            // {name = Sylvia; address = null; age = 12;}
        }
        // :code-block-end:
    }
}
// :replace-end:
