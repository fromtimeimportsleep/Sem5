public class Student extends Person{
    public Student(String fst, String lst){
        super(fst,lst);
    }public void say(String txt){
        System.out.println("Excuse me, "+txt);
    }
    public void question(){
        System.out.println("How?? ");
    }
}
// if no parent Object in java.lang is parent
//inherence exists to support runtime polymorphism