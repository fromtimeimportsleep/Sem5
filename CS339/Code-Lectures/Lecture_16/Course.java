import java.util.Set;
import java.util.HashSet;

public class Course {
    int number;
    Professor prof;
    Set<Student> studs;

    public Course(int num, Professor prof) {
        number = num;
        this.prof = prof;
        studs = new HashSet<Student>();
    }

    public void addStudent(Student s) {
        studs.add(s);
    }

    public void start() {
        prof.lecture("The syllabus is over.");
        for (Student s : studs) {
            s.question();
            prof.answer(s);
        }
    }
}
