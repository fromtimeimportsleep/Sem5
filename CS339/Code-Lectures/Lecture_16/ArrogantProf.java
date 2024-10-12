public class ArrogantProf extends Professor {
    public ArrogantProf(String fst, String lst) {
        super(fst, "Snape");
    }

    public void say(String text) {
        super.say(text + ", stupid.");
    }

    public void answer(Person seeker) {
        if (seeker instanceof Student) {
            System.out.println(seeker.whoAreYou() + ", you should already be knowing this.");
        } else if (seeker instanceof Professor) {
            System.out.println(seeker.whoAreYou() + ", why don't ask this to a student?");
        }
    }
}
