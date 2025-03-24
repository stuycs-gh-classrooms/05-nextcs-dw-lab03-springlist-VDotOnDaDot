/*===========================
  OrbList (ALL WORK GOES HERE)

  Class to represent a Linked List of OrbNodes.

  Instance Variables:
    OrbNode front:
      The first element of the list.
      Initially, this will be null.

  Methods to work on:
    0. addFront
    1. populate
    2. display
    3. applySprings
    4. applyGravity
    5. run
    6. removeFront
    7. getSelected
    8. removeNode

  When working on these methods, make sure to
  account for null values appropraitely. When the program
  is run, no NullPointerExceptions should occur.
  =========================*/

class OrbList {

  OrbNode front;

  /*===========================
    Contructor
    Does very little.
    You do not need to modify this method.
    =========================*/
  OrbList() {
    front = null;
  }//constructor

  /*===========================
    addFront(OrbNode o)

    Insert o to the beginning of the list.
    =========================*/
  void addFront(OrbNode o) {
    // If the list is not empty, connect the new node to the current front
    if (front != null) {
      o.next = front;      // Set the new node's next to current front
      front.previous = o;  // Set current front's previous to the new node
    }
    front = o;  // Update front pointer to the new node
  }//addFront


  /*===========================
    populate(int n, boolean ordered)

    Clear the list.
    Add n randomly generated orbs to the list,
    using addFront.
    If ordered is true, the orbs should all
    have the same y coordinate and be spaced
    SPRING_LEGNTH apart horizontally.
    =========================*/
  void populate(int n, boolean ordered) {
    // Clear the list
    front = null;
    
    if (ordered) {
      // Create an ordered list with orbs in a horizontal line
      float y = height / 2;  // Center vertically
      float x = width - SPRING_LENGTH;  // Start from right side
      
      for (int i = 0; i < n; i++) {
        // Create new node with specific position but random size and mass
        OrbNode newNode = new OrbNode(x, y, random(MIN_SIZE, MAX_SIZE), random(MIN_MASS, MAX_MASS));
        addFront(newNode);
        x -= SPRING_LENGTH;  // Move left by SPRING_LENGTH for next orb
      }
    } else {
      // Create a list with random orbs
      for (int i = 0; i < n; i++) {
        OrbNode newNode = new OrbNode();  // Use default constructor for random values
        addFront(newNode);
      }
    }
  }//populate

  /*===========================
    display(int springLength)

    Display all the nodes in the list using
    the display method defined in the OrbNode class.
    =========================*/
  void display() {
    // Traverse the list and display each node
    OrbNode current = front;
    while (current != null) {
      current.display();
      current = current.next;  // Move to next node
    }
  }//display

  /*===========================
    applySprings(int springLength, float springK)

    Use the applySprings method in OrbNode on each
    element in the list.
    =========================*/
  void applySprings(int springLength, float springK) {
    // Apply spring forces to each node in the list
    OrbNode current = front;
    while (current != null) {
      current.applySprings(springLength, springK);
      current = current.next;
    }
  }//applySprings

  /*===========================
    applyGravity(Orb other, float gConstant)

    Use the getGravity and applyForce methods
    to apply gravity correctly.
    =========================*/
  void applyGravity(Orb other, float gConstant) {
    // Apply gravitational force from 'other' to each node
    OrbNode current = front;
    while (current != null) {
      // Calculate gravitational force vector
      PVector gravForce = current.getGravity(other, gConstant);
      // Apply the force to the current node
      current.applyForce(gravForce);
      current = current.next;
    }
  }//applyGravity

  /*===========================
    run(boolean bounce)

    Call run on each node in the list.
    =========================*/
  void run(boolean bounce) {
    // Update the position of each node based on forces
    OrbNode current = front;
    while (current != null) {
      current.move(bounce);  // Move with or without bounce behavior
      current = current.next;
    }
  }//run

  /*===========================
    removeFront()

    Remove the element at the front of the list, i.e.
    after this method is run, the former second element
    should now be the first (and so on).
    =========================*/
  void removeFront() {
    if (front != null) {
      // Get the second node (which will become the new front)
      OrbNode newFront = front.next;
      
      // If there is a second node, remove its previous reference
      if (newFront != null) {
        newFront.previous = null;
      }
      
      // Update the front pointer
      front = newFront;
    }
  }//removeFront


  /*===========================
    getSelected(float x, float y)

    If there is a node at (x, y), return
    a reference to that node.
    Otherwise, return null.

    See isSelected(float x, float y) in
    the Orb class (line 115).
    =========================*/
  OrbNode getSelected(int x, int y) {
    // Find the node that contains the point (x,y)
    OrbNode current = front;
    
    while (current != null) {
      // Check if current node contains the point
      if (current.isSelected(x, y)) {
        return current;  // Node found
      }
      current = current.next;
    }

    // No node contains the point
    return null;
  }//getSelected

  /*===========================
    removeNode(OrbNode o)

    Removes o from the list. You can
    assume o is an OrbNode in the list.
    You cannot assume anything about the
    position of o in the list.
    =========================*/
  void removeNode(OrbNode o) {
    // Special case: removing the front node
    if (o == front) {
      removeFront();
      return;
    }
    
    // Handle connections for internal node
    // Connect the previous node to the next node
    if (o.previous != null) {
      o.previous.next = o.next;
    }
    
    // Connect the next node to the previous node
    if (o.next != null) {
      o.next.previous = o.previous;
    }
  }
  
  /*===========================
    debug()
    
    Prints information about the list for debugging.

    =========================*/
  void debug() {
    // Count nodes and check list integrity
    int count = 0;
    OrbNode current = front;
    
    println("--- DEBUG LIST INFO ---");
    
    // List is empty
    if (front == null) {
      println("List is EMPTY (front is null)");
      return;
    }
    
    // Print front node info
    println("Front node: ", front);
    println("Front position: (", front.center.x, ",", front.center.y, ")");
    
    // Traverse forward and count
    println("Forward traversal:");
    while (current != null) {
      count++;
      println("Node", count, ": pos(", current.center.x, ",", current.center.y, 
              "), prev:", (current.previous == null ? "null" : "exists"), 
              ", next:", (current.next == null ? "null" : "exists"));
      
      // Verify connections are correct
      if (current.next != null && current.next.previous != current) {
        println("ERROR: Broken link between node", count, "and next node");
      }
      
      current = current.next;
    }
    
    println("Total nodes: " + count);
    println("---------------------");
  }
}//OrbList
