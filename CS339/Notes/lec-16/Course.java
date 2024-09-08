import java.util.Set;
import java.util.HashSet;
public class Course{
    int number;
    Prof prof;
    Set<Student> studs;

    public Course(int num, Prof p){
        number=num;
        prof=p;
        studs= new HashSet<Student>();
    }

    public void start(){
        prof.say("The syllabus is over.");
        for(Student s:studs){
            s.question();
            prof.answer(s);
        }
    }
    public void addStudent(Student s){
        studs.add(s);
    }
}