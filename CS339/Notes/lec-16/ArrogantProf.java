public class ArrogantProf extends Prof{
    public ArrogantProf(string fst, String lst){
        super(fst, "Snape");
    }
    public void say(String txt ){
        say(txt + " , stupid");
    }
    public void answer(Person p){
        if (p instanceof Student){
            System.out.println("You should already be knowing this")
        }
        else if( p instanceof Prof){
            System.out.println("why dont you Ask a studnet")
        }
    }
}
// Student 
// ^
// |
// Person <- Prof <-ArrogantProf 
