public class Person {
    String firstName;
    String lastName;

    public Person(String fst, String lst) {
        firstName = fst;
        lastName = lst;
    }

    public String whoAreYou() {
        return firstName + " " + lastName;
    }

    public void say(String text) {
        System.out.println(text);
    }
}
