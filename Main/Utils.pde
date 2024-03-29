/*
Funções auxiliares de variados tipos.
*/

PVector strToVector(String str) {
    String[] pntArr = split(str.replace("(", "").replace(")", ""), ",");
    return new PVector(Integer.parseInt(pntArr[0]), Integer.parseInt(pntArr[1]), Integer.parseInt(pntArr[2]));
}

float strToFloat(String str) {
    return (float)Double.parseDouble(str);
}

float[][][] assembleFacesFromVertex(float[][] vertex) {
    return new float[][][]{
                      {vertex[0], vertex[1], vertex[2], vertex[3], vertex[4], vertex[5], vertex[6], vertex[7]}, //OK
                      {vertex[15], vertex[14], vertex[13], vertex[12], vertex[11], vertex[10], vertex[9], vertex[8]}, //OK
                      {vertex[8], vertex[0], vertex[7], vertex[15]}, // OK
                      {vertex[15], vertex[14], vertex[6], vertex[7]}, //OK
                      {vertex[5], vertex[13], vertex[14], vertex[6]}, //OK
                      {vertex[13], vertex[12], vertex[4], vertex[5]}, //OK
                      {vertex[12], vertex[4], vertex[3], vertex[11]}, //OK
                      {vertex[11], vertex[10], vertex[2], vertex[3]}, //OK
                      {vertex[1], vertex[9], vertex[10], vertex[2]}, //OK
                      {vertex[0], vertex[8], vertex[9], vertex[1]}}; //OK
}

float[][] calculaNormal(float[][][] faces){
  float[][] normais = new float[faces.length][3];

  int i = 0;
  for(float[][] vertices : faces){
    float[] v1 = vertices[0];
    float[] v2 = vertices[1];
    float[] v3 = vertices[2];

    PVector p1 = new PVector(v1[0], v1[1], v1[2]);
    PVector p2 = new PVector(v2[0], v2[1], v2[2]);
    PVector p3 = new PVector(v3[0], v3[1], v3[2]);

    p1.sub(p2);
    p3.sub(p2);
    
    PVector n = p3.cross(p1);

    //n.normalize();
    
    normais[i][0] = n.x;
    normais[i][1] = n.y;
    normais[i][2] = n.z;

    //println("X: " + n.x + " Y: " + n.y + " Z: " + n.z);

    i++;
  }
  return normais;
}



int[] pointsToCp(String p1, String p2, String p3,String p4){
  int cp[] = new int[12];
  String[] p1Str = split(p1.replace("(", "").replace(")", ""), ",");
  String[] p2Str = split(p2.replace("(", "").replace(")", ""), ",");
  String[] p3Str = split(p3.replace("(", "").replace(")", ""), ",");
  String[] p4Str = split(p4.replace("(", "").replace(")", ""), ",");
  
  for (int i = 0; i<3; i++){
    cp[i] = Integer.parseInt(p1Str[i]);
    cp[i+3] = Integer.parseInt(p2Str[i]);
    cp[i+6] = Integer.parseInt(p3Str[i]);
    cp[i+9] = Integer.parseInt(p4Str[i]);
  }
  
  return cp;
}

void drawBezier(int[] cp) {
  stroke(255,0,0);
  for(float i = 0; i<1; i = i + 0.0015){
      float posXp = (float) (Math.pow((1-i), 3)*cp[0] + 3*Math.pow((1-i), 2)*i*cp[3] + 3*(1-i)*Math.pow(i, 2)*cp[6] + Math.pow(i, 3)*cp[9]);
      float posYp = (float) (Math.pow((1-i), 3)*cp[1] + 3*Math.pow((1-i), 2)*i*cp[4] + 3*(1-i)*Math.pow(i, 2)*cp[7] + Math.pow(i, 3)*cp[10]);
      float posZp = (float) (Math.pow((1-i), 3)*cp[2] + 3*Math.pow((1-i), 2)*i*cp[5] + 3*(1-i)*Math.pow(i, 2)*cp[8] + Math.pow(i, 3)*cp[11]);
      point(posXp + 25, posYp + 25);
  }
  stroke(0, 0, 0);
}

float[][] translateObjectThroughBezier(float[][] vertex, PVector translation) {
  float[][] result = new float[vertex.length][vertex[0].length];
  for (int i = 0; i < vertex.length; i++) {
    float[] w = translate(vertex[i], translation);
    result[i] = w;
  }
  return result;
}

PVector getBezierPoint(float t, int[] cp) {
  int posXp = (int) (Math.pow((1-t), 3)*cp[0] + 3*Math.pow((1-t), 2)*t*cp[3] + 3*(1-t)*Math.pow(t, 2)*cp[6] + Math.pow(t, 3)*cp[9]);
  int posYp = (int) (Math.pow((1-t), 3)*cp[1] + 3*Math.pow((1-t), 2)*t*cp[4] + 3*(1-t)*Math.pow(t, 2)*cp[7] + Math.pow(t, 3)*cp[10]);
  int posZp = (int) (Math.pow((1-t), 3)*cp[2] + 3*Math.pow((1-t), 2)*t*cp[5] + 3*(1-t)*Math.pow(t, 2)*cp[8] + Math.pow(t, 3)*cp[11]);
  return new PVector(posXp, posYp, posZp);
}

float[] translate(float[] v, PVector dist) {
  PVector w = new PVector(v[0], v[1]);
  w.add(dist);
  return new float[]{ w.x, w.y, v[2] };
}

float[][] rotate(float[][] vertex, float ang, PVector axis) {
  Rotation r = new Rotation(ang, axis);
  float[][] result = new float[vertex.length][vertex[0].length];
  for (int i = 0; i < vertex.length; i++) {
    float[] w = r.rotate(vertex[i]);
    result[i] = w;
  }
  return result;
}