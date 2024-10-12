public class Professor extends Person {
    public Professor(String fst, String lst) {
        super("Prof. "+fst, lst);
    }

    public void lecture(String text) {
        say("Therefore, " + text);
    }

    public void question() {
        System.out.println("Professor's question: blah blah");
    }

    public void answer(Person seeker) {
        System.out.println("Dear " + seeker.whoAreYou() + ", let's discuss this offline.");
    }
}
