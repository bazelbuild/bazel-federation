/**
 * Hello Bazel.
 */

package example;

import example.HelloLib;

final class Hello {

  public static void main(String[] args) {
    System.out.println("Hello " + HelloLib.HelloLibValue);
  }
}
