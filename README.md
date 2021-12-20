# 11.Renderpipeline---stencil-simple
This is a simple stencil test case with SRP.

Stencil ref value is 2 in this case.

Valid shaders (used shaders) in this project is `red.shader` and `green.shader`

----

Vedio demo: https://drive.google.com/file/d/1bCTtRschASdL2b993IssOkMRFHG8T924/view?usp=sharing

Main Logic:

For the quad:
```
Stencil {
            Ref 2          //0-255
            Comp always     // compare stencil value - always pass in this case
            Pass replace   // if pass, replace current stencil value with ref value (2 here)

        }
```

For the cube:
```
Stencil {
            Ref 2          //0-255
            Comp equal     // compare stencil value - only equal to 2 can be rendered

        }
```
        
        
