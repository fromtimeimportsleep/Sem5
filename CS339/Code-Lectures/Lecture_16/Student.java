public class Student extends Person {
    int rollNum;
    public Student(String fst, String lst, int rNum) {
        super(fst, lst);
        rollNum = rNum;
    }

    public void say(String text) {
        super.say("Excuse me, " + text);
    }

    public void question() {
        System.out.println("Student's question: meh meh");
    }

    @Override
    public int hashCode() {
        return rollNum;
    }

    @Override
    public boolean equals(Object other) {
        if (!(other instanceof Student)) {
            return false;
        }
        return this.rollNum == ((Student) other).rollNum;
    }
}
