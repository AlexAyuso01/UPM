package lex;
public class Estado {
    // create all the 18 states 
    // el value esta puesto a true si no son terminales y a false si lo son
    static final Par <String,Boolean> e1 = new Par<>("1", true);
    static final Par <String,Boolean> e2 = new Par<>("2", true);
    static final Par <String,Boolean> e3 = new Par<>("3", false);
    static final Par <String,Boolean> e4 = new Par<>("4", true);
    static final Par <String,Boolean> e5 = new Par<>("5", false);
    static final Par <String,Boolean> e6 = new Par<>("6", true);
    static final Par <String,Boolean> e7 = new Par<>("7", false);
    static final Par <String,Boolean> e8 = new Par<>("8", true);
    static final Par <String,Boolean> e9 = new Par<>("9", false);
    static final Par <String,Boolean> e10 = new Par<>("10", true);
    static final Par <String,Boolean> e11 = new Par<>("11", false);
    static final Par <String,Boolean> e12 = new Par<>("12", false);
    static final Par <String,Boolean> e13 = new Par<>("13", true);
    static final Par <String,Boolean> e14 = new Par<>("14", false);
    static final Par <String,Boolean> e15 = new Par<>("15", true);
    static final Par <String,Boolean> e16 = new Par<>("16", false);
    static final Par <String,Boolean> e17 = new Par<>("17", false);
    static final Par <String,Boolean> e18 = new Par<>("18", false);   

}
