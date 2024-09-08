// Professor is a person IS-A - inheritance
public class Prof extends Person {
    public Prof(String fst , String lst){
        super("Prof. "+fst,lst);
    }
    public void say(txt){ //can redefine the original class methods
        super.say("Therefore, "+txt)
    }
    public void answer(Person p){
        System.out.println("Dear ")
    }
    public String name(){
        return firstName + " " + lastName
    }
    public void answer(Person P){
        System.out.println("Dear "+p.name+" lets discuss offline");
    }
    public class ask(){
        System.out.println("Blah Blaah");
    }
}