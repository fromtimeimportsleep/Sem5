public class Person{
    String firstName; //HAS-A - composition
    String lastName;

    public Person(String fst, String lst){ //instantiation initializes an object 
        firstName=fst; //initialization
        lastName=lst; 
    } //constructore returns reference to object  Person P = new Person("a","x");
    public void say(String txt){
        System.out.println(txt); //System is a class it has a feild out and println is a method 
    }
    

}
