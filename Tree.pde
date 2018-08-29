class Tree {

  // member variables
  float    m_lineLength;       // turtle line length
  int    m_x;                // initial x position
  int    m_y;                // initial y position
  float  m_branchAngle;      // turtle rotation at branch
  float  m_initOrientation;  // initial orientation
  String m_state;            // initial state
  float  m_scaleFactor;      // branch scale factor
  String m_F_rule;           // F-rule substitution
  String m_H_rule;           // H-rule substitution
  String m_f_rule;           // f-rule substitution
  int    m_numIterations;    // number of times to substitute
  float  m_hue;
  
  // constructor
  // (d = line length, x & y = start position of drawing, angle = angle of branching, iternations = number of iterations done, treeHue = tree's colour)
  Tree(float d, int x, int y, float angle, int iterations, float treeHue) {
    m_lineLength = d;
    m_x = x;
    m_y = y; 
    m_branchAngle = angle;
    m_initOrientation = -HALF_PI;
    m_scaleFactor = 1;
    m_state = "F";
    m_F_rule = "F[+F]F[-F]F";
    m_H_rule = "";
    m_f_rule = "";
    m_numIterations = iterations;
    m_hue = treeHue;

    // Perform L rounds of substitutions on the initial state
    for (int k=0; k < m_numIterations; k++) {
      m_state = substitute(m_state);
    }
  }
  
  void draw() {
    pushMatrix();
    pushStyle();
    colorMode(HSB,TWO_PI,1,1);
    stroke(m_hue,1,1);
    translate(m_x, m_y);        // initial position
    rotate(m_initOrientation);  // initial rotation
    
    // now walk along the state string, executing the
    // corresponding turtle command for each character
    for (int i=0; i < m_state.length(); i++) {
      turtle(m_state.charAt(i));
    }
    
    popStyle();
    popMatrix();
  }
  
  // Turtle command definitions for each character in our alphabet
  void turtle(char c) {
    switch(c) {
    case 'F': // drop through to next case
    case 'H':
      line(0, 0, m_lineLength, 0);
      translate(m_lineLength, 0);
      break;
    case 'f':
      translate(m_lineLength, 0);
      break;
    case 's':
      scale(m_scaleFactor);
      break;
    case '-':
      rotate(m_branchAngle);
      break;
    case '+':
      rotate(-m_branchAngle);
      break;
    case '[':
      pushMatrix();
      break;
    case ']':
      popMatrix();
      break;
    default:
      println("Bad character: " + c);
      exit();
    }
  }
  
  // apply substitution rules to string s and return the resulting string
  String substitute(String s) {
    String newState = new String();
    for (int j=0; j < s.length(); j++) {
      switch (s.charAt(j)) {
      case 'F':
        newState += m_F_rule;
        break;
      case 'H':
        newState += m_H_rule;
        break;
      case 'f':
        newState += m_f_rule;
        break;
      default:
        newState += s.charAt(j);
      }
    }
    return newState;
  }
  
}
