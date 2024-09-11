public class Tester {
    public static void main(String[] args) {
        Person p1, p2;
        Student s;
        p1 = new Professor("Albus", "Dumbledore");
        p2 = new ArrogantProf("Severus", "Snape");
        s = new Student("Hermione", "Granger", 101);

        System.out.println();

        s.say("Good morning, Prof.");
        p2.say("This is a bad morning");
        System.out.println();

        ((Professor) p1).question();
        ((Professor) p2).answer(p1);
        System.out.println();
        System.out.println();

        Course c = new Course(420, (Professor) p1);
        c.addStudent(s);
        c.addStudent(new Student("Hermione", "Granger", 101));
        c.start();
    }
}
