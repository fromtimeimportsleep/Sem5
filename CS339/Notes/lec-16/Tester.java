public class Tester{
    public static void main(String[] args){
        Person p1,p2; // expects Prof in cso does not work IS-A does not work
        // Prof p1,p2; // Prof can be sent if method needs person but not vice-versa
        Student s;
        Course c;
        p1 =  new Prof("Albus", "Dumbledore");
        p2= new Prof("Severus", "Snape");
        s=new Student("Harry","Potter");
        p1.say()
        // (ArrogantProf p1).say() //runtime error not compile time 
        //  c = new Course(420,p1);
         // Person p1,p2;
         c = new Course(420,(Prof)p1);
        c.add(s);
        c.start();

    //     Person p;
    //     int x=1;
    //     if(x){
    //         p = new Prof();
    //     }
    //     else{
    //         p= new Student();
    //     }
    //     p.foo(); //polymorphism
    }
}