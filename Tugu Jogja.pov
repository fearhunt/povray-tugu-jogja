#version 3.7;
global_settings{ assumed_gamma 1.0 }
#default{ finish{ ambient 0.1 diffuse 0.9 }} 
//--------------------------------------------------------------------------
#include "colors.inc"
#include "textures.inc"  
#include "golds.inc"
#include "stones.inc"
#include "shapes.inc"
#include "shapes2.inc"
#include "functions.inc"
#include "math.inc"                            
// sun ---------------------------------------------------------------------
light_source{<0,2000,-2500> color White}

// sky -------------------------------------------------------------- 
plane {
    <0,1,0>,1 hollow  
    texture{ 
        pigment { 
            bozo turbulence 0.92
            color_map { [0.00 rgb <0.20, 0.20, 1.0>*0.9]
                        [0.50 rgb <0.20, 0.20, 1.0>*0.9]
                        [0.70 rgb <1,1,1>]
                        [0.85 rgb <0.25,0.25,0.25>]
                        [1.0 rgb <0.5,0.5,0.5>]}
            scale<1,1,1.5>*2.5  
            translate< 0,0,0>
        }
        finish {ambient 1 diffuse 0} 
    }      
    scale 10000
}          

// fog on the ground -------------------------------------------------
fog { 
        fog_type   2
        distance   150
        color      White  
        fog_offset 0.1
        fog_alt    1.5
        turbulence 1.8
}  

// ground
plane {
    <0,1,0>, 0 
    texture { 
        T_Stone16
        finish { phong 0.5 } 
        scale 1 
    } // end of texture 
}     

//Diglett Perspective
#declare MainCamera = camera {    
    location <7,6,-15>
    look_at <0, 4, 0>   
    angle 100  
}

#declare FrontCamera = camera {
    location <0,6,-15>
    look_at <0, 4, 0>   
    angle 100           
} 

#declare LeftCamera = camera {
    location <0,15,0>
    look_at <0, 4, 0>   
    angle 100           
}

camera{MainCamera}
// --------------------------------------------------------------------------------- 
// Grass texture
#declare Tan1 = rgb< 0.76,0.58,0.34>;
#declare Green1=rgb<0.4,0.7,0.15>*0.1;
#declare Green2=rgb<0.27,0.63,0.12>*0.6;
//----------------------------------
#declare P_Spotted =pigment {
spotted
    color_map {
        [0.0  color Tan1*0.1 ]
        [0.4  color Tan1*0.4 ]
        [0.6  color Green1*0.9 ]
        [1.01 color Green1*1.1 ]
    }
}//---------------------------------
#declare P_Earth =pigment {
    spotted
    color_map {
        [0 color Tan*0.3]
        [0.6 color Tan*0.3]
        [0.6 color Green1*0.4]
        [1   color Green1*0.6]
    }
}//---------------------------------
#declare P_Green=pigment{Green2*1.3}
#declare T_Grass=texture {                  
    pigment {
        gradient y
        turbulence 0.2
        pigment_map {                                
            [0.0 P_Earth]
            [0.1 P_Green]
            [0.9 P_Spotted]
            [1.00 P_Earth]
        }
    }
    finish{ specular 0.5 roughness 0.035}
    scale <0.001,1,0.001>
} //---------------------------------------------------------------------------- end Grass texture

#include "makegrass.inc"
#declare lPatch=20;               // size of patch
#declare nBlade=15;                // number of blades per line (there will be nBlade * nBlade blades)
#declare ryBlade = 0;            // initial y rotation of blade
#declare segBlade= 10;            // number of blade segments
#declare lBlade = 10;             // length of blade
#declare wBlade = 1.0;            // width of blade at start
#declare wBladeEnd = 0.1;         // width of blade at the end
#declare doSmooth= 1;          // true makes smooth triangles
#declare startBend = <0,1,0.8>;   // bending of blade at start (<0,1,0>=no bending)
#declare vBend = <0,1,2>;         // force bending the blade (<0,1,1> = 45�)
#declare pwBend =4;              // bending power (how slowly the curve bends)
#declare rd = 111;                // seed
#declare stdposBlade = 1;         // standard deviation of blade position 0..1
#declare stdrotBlade = 360;       // standard deviation of rotation
#declare stdBlade = 1.2;           // standard deviation of blade scale
#declare stdBend = 10;            // standard deviation of blade bending
#declare dofold = 1;//false;/true; or 0;/1; // true creates a central fold in the blade (twice more triangles)
#declare dofile = 0;//false;/true; or 0;/1; // true creates a mesh file
#declare fname = "fgrass2.inc"     // name of the mesh file to 
// Prairie parameters
#declare nxPrairie=15;             // number of patches for the first line
#declare addPatches=0;            // number of patches to add at each line
#declare nzPrairie=58;             // number of lines of patches
#declare rd=seed(179);            // random seed
#declare stdscale=1;              // stddev of scale
#declare stdrotate=1;             // stddev of rotation
#declare doTest=0;//false;/true; or 0;/1; // replaces the patch with a sphere
// -----------------------------------------------------------------------------------------------
// Create the patch 
#if (dofile=true) // if the patch is already created, turn off the next line
   MakeGrassPatch(lPatch,nBlade,ryBlade,segBlade,lBlade,wBlade,wBladeEnd,doSmooth,startBend,vBend,pwBend,rd,stdposBlade,stdrotBlade,stdBlade,stdBend,dofold,dofile,fname)
   #declare objectPatch=#include fname
#else        
   #declare objectPatch=object{MakeGrassPatch(lPatch,nBlade,ryBlade,segBlade,lBlade,wBlade,wBladeEnd,doSmooth,startBend,vBend,pwBend,rd,stdposBlade,stdrotBlade,stdBlade,stdBend,dofold,dofile,fname)}
#end        
// -----------------------------------------------------------------------------------------------
// Create the prairie
object{MakePrairie(lPatch,nxPrairie,addPatches,nzPrairie,objectPatch,rd,stdscale,stdrotate,doTest)
    scale 1/40
    texture{T_Grass }
    scale 0.41  
    translate<-4.84,0,-5.7>  
} 
object{MakePrairie(lPatch,nxPrairie,addPatches,nzPrairie,objectPatch,rd,stdscale,stdrotate,doTest)
    scale 1/40
    texture{T_Grass }
    scale 0.41  
    translate<-2.5,0,-5.7>  
}
object{MakePrairie(lPatch,nxPrairie,addPatches,nzPrairie,objectPatch,rd,stdscale,stdrotate,doTest)
    scale 1/40
    texture{T_Grass }
    scale 0.41  
    translate<0,0,-5.7>  
}              
object{MakePrairie(lPatch,nxPrairie,addPatches,nzPrairie,objectPatch,rd,stdscale,stdrotate,doTest)
    scale 1/40
    texture{T_Grass }
    scale 0.41  
    translate<2.5,0,-5.7>  
} 
object{MakePrairie(lPatch,nxPrairie,addPatches,nzPrairie,objectPatch,rd,stdscale,stdrotate,doTest)
    scale 1/40
    texture{T_Grass }
    scale 0.41  
    translate<5,0,-5.7>  
}  
// -----------------------------------------------------------------------------------------------

//=========================================================================
//Texture
#declare TextureTugu = 
    texture {
        T_Stone8 
        scale 0.3 pigment{quick_color White}
        normal{bumps 0.4 scale 0.007}
        finish {ambient 0.8 diffuse 0.9 phong 1}
    } 

#declare TextureGolden =
    texture {
        pigment{ color Gold}
        normal { bumps 0.4 scale 0.007}
        finish { ambient 0.16 diffuse 1.8 phong 1}
    }
//========================================================================= 
#declare CustomDiskX = object {
    Disk_X // no open available!
    texture{ TextureTugu } // end of texture 
    scale <0.8,0.25,0.125>
    rotate<0,0,0>  
}

#declare Edge = union {
    Supertorus(
        0.67, 0.2,// R_Major, R_Minor,
        0.25, 1.45,// Maj_Control, Min_Control,
        0.001,1.50)// Accuracy, Max_Gradient)

        texture{ TextureTugu } // end of texture
} 

#declare OrnamentCenter = union {
    union {
        box{ <-0.45,0.45,-0.02>,< -0.25,0.55,0.02> translate<-0.1,1.5,0> }
        box{ <-0.45,0.45,-0.02>,< -0.25,0.55,0.02> translate<0.35,1.5,0> }
        box{ <-0.45,0.45,-0.02>,< -0.25,0.55,0.02> translate<0.8,1.5,0> }
        box{ <-0.45,0.45,-0.02>,< -0.25,0.55,0.02> translate<-0.1,0.1,0> }
        box{ <-0.45,0.45,-0.02>,< -0.25,0.55,0.02> translate<0.8,0.1,0> }
    } 

    difference{       
        box{<-0.45,0.65,-0.02>,< 0.45,1.95,0.02>} 
        box{<-0.3,0.8,-0.03>,< 0.3,1.75,0.03>} 
    } // --- end of difference 

    texture{ TextureGolden }
} 

#declare BlackWhiteBox = union {
    box{
        <-0.40,0.00,-0.20>,<0.40,0.20,0.20>
        texture { 
            pigment { color White } 
            finish {ambient 0.57 diffuse 0.5 phong 1 }  
        }
    }
    
    box {
        <-0.40,0.00,-0.20>,<0.40,0.20,0.20>
        texture { 
            pigment { color Gray10 } 
            finish {ambient 0.001 diffuse 0.5 phong 1 }  
        } 
        translate<-0.80,0,0>
    } 
}                            

#declare DividerCenter = difference {
    box{ <-0.8 ,2.25,-0.8 >,<0.8 ,2.6,0.8 > texture { TextureTugu } }     
    
    intersection {
        object{ CustomDiskX translate<0.0,2.25,0> }
        box{<-0.81, 2.24 ,-0.175 >,<0.81,2.5,0.175 > } 
        
        translate<0,0,-0.8> 
    }
    
    intersection {
        object{ CustomDiskX translate<0.0,2.25,0> }
        box{<-0.81, 2.24 ,-0.175 >,<0.81,2.5,0.175 > } 
        
        translate<0,0,0.8>
    }
    
    intersection {
        object{ CustomDiskX translate<0.0,2.25,0> }
        box{<-0.81, 2.24 ,-0.175 >,<0.81,2.5,0.175 > } 
        
        rotate<0,90,0>
        translate<-0.8,0,0>
    }
    
    intersection {
        object{ CustomDiskX translate<0.0,2.25,0> }
        box{<-0.81, 2.24 ,-0.175 >,<0.81,2.5,0.175 > } 
        
        rotate<0,90,0>
        translate<0.8,0,0>
    }        
}

#declare LineOrnament = 
    box { <-0.1, 0, -0.01>,<0.1, 2.7, 0.01> texture { TextureGolden}  rotate<2.5,0,0> }    

#declare Slab = 
    box { <-0.12,0 , -0.12>, <0.12, .05, 0.12> texture{ TextureGolden } translate<0,0.4,0> }

#declare index_loop = 0;
#declare fence_index_loop = 0;

// OBJEK COMPILE
// ========================================================
// OBJEK COMPILE    
union{     
    // set puncak
    union {
        #while (index_loop<1000)
            #declare responsive_scale = 1-0.001*index_loop;
            object{Slab rotate <0,index_loop,0> translate <0,0.002*index_loop,0> scale<responsive_scale,1,responsive_scale>}
            #declare index_loop=index_loop+1;
        #end      
        
        cone{ <0,0,0>, 0.5, <0,0.4,0>, 0.2 texture {TextureTugu}}
        box {<-0.4,0,-0.4>,<0.4,0.275,0.4> texture {TextureTugu} } 
        
        object{ Edge texture { TextureGolden } scale<0.6,0.6,0.6> translate<0,0.16,0> }                                                       
        object{ Edge texture { TextureTugu } scale<0.635,0.635,0.635> translate<0,0.08,0> }
        object{ Edge texture { TextureGolden } scale<0.6,0.6,0.6> }
        
        translate<0,7.55,0>
    }
    
    // menuju puncak
    union{     
        // kombinasi LineOrnament
        object { LineOrnament rotate<0,0,0> translate<0,0.3,-0.5> }
        object { LineOrnament rotate<0,180,0> translate<0,0.3,0.5> }
        object { LineOrnament rotate<0,-90,0> translate<0.5,0.3,0> } 
        object { LineOrnament rotate<0,90,0> translate<-0.5,0.3,0> }
        
        // tiang
        difference {
            box { <-0.8, 0, -0.8>,<0.8, 3.5,0.8> texture { TextureTugu } }   
            
            object {
                box { <-0.8, 0, -0.5>,<0.8, 3.6 ,0.5> texture { TextureTugu } translate<0,-0.05,-1> rotate<2.5,0,0> }
                
                rotate<0,0,0>
            }

            object {
                box { <-0.8, 0, -0.5>,<0.8, 3.6 ,0.5> texture { TextureTugu } translate<0,-0.05,-1> rotate<2.5,0,0> }
                
                rotate<0,90,0>
            }
            
            object {
                box { <-0.8, 0, -0.5>,<0.8, 3.6 ,0.5> texture { TextureTugu } translate<0,-0.05,-1> rotate<2.5,0,0> }
                
                rotate<0,-90,0>
            } 
            
            object {
                box { <-0.8, 0, -0.5>,<0.8, 3.6 ,0.5> texture { TextureTugu } translate<0,-0.05,1> rotate<-2.5,0,0> }
                
                rotate<0,0,0>
            }
        }                       
        
        translate<0,4.05,0>
    }
    
    // tengah
    union{      
        object{DividerCenter} 
        
        box{ <-0.7 ,2.15,-0.7 >,<0.7 ,2.25,0.7 > texture { TextureGolden } }  

        object{OrnamentCenter rotate<-1,0,-1> translate<0,-0.2,0.7>}
        object{OrnamentCenter rotate<0,0,0> translate<0,-0.2,-0.65>}
        object{OrnamentCenter rotate<0,90,0> translate<0.65,-0.2,0>}
        object{OrnamentCenter rotate<0,90,0> translate<-0.65,-0.2,0>}       
        
        box{<-0.65,0.0,-0.65>,<0.65,2.15,0.65> texture{ TextureTugu } }      
        
        object{Edge}  

        translate<0,1.45,0>
    }   
    
    // fondasi   
    union{ 
        box{<-0.80,0.95,-0.80>,<0.80,1.25,0.80>} 
        box{<-0.90,0.60,-0.90>,<0.90,0.95,0.90>} 
        box{<-1.20,0.40,-1.20>,<1.20,0.60,1.20>}    
        box{<-1.50,0.20,-1.50>,<1.50,0.40,1.50>}   
        box{<-1.80,0.00,-1.80>,<1.80,0.20,1.80>}  
        
        texture{ TextureTugu  } 
    }  
    
    // pembatas tugu
    union {
        #while (fence_index_loop<10)            
            #declare check=1.615*fence_index_loop;
            object{BlackWhiteBox translate <check,0,-1.75>} // depan
            object{BlackWhiteBox translate <check,0,13.95>} // belakang
            object{BlackWhiteBox translate <-13+check,0,15.12> rotate <0,90,0>} // kanan
            object{BlackWhiteBox translate <-13+check,0,-1.4> rotate <0,90,0>}  // kiri
            #declare fence_index_loop=fence_index_loop+1;
        #end
        translate<-6.9,0,-6>  
        scale<0.6,0.6,0.6>
    }    
    
    
    scale <1.3,1.3,1.3> rotate<0,0,0> translate<0,0,0>
}            