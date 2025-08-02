
var linea = "Esta linea no tiene virgulilla~done";

var split = linea.split("~");

console.log(split);

if(!split[split.length-1] === "done"){

    console.log("Tarea no hecha");

}else{

    console.log("Tarea hecha");
}