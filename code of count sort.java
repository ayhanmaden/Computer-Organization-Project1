/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package bg;

import java.util.Arrays;



class CountingSort {
  void countSort(int array[], int size) {
    int[] output = new int[size + 1];

    int max = array[0];
    for (int i = 1; i < size; i++) {
      if (array[i] > max)
        max = array[i];
    }
    int[] count = new int[max + 1];

    for (int i = 0; i < max; ++i) {
      count[i] = 0;
    }

    for (int i = 0; i < size; i++) {
      count[array[i]]++;
    }
    for (int i = 1; i <= max; i++) {
      count[i] += count[i - 1];
    }
    for (int i = size - 1; i >= 0; i--) {
      output[count[array[i]] - 1] = array[i];
      count[array[i]]--;
    }
    for (int i = 0; i < size; i++) {
      array[i] = output[i];
    }
  }

  public static void main(String args[]) {
    int[] data = { 3 ,0 ,2 ,2 ,0 ,0 ,4 ,5 ,3 ,3 ,2, 2 ,4  };
    int size = data.length;
    CountingSort cs = new CountingSort();
    cs.countSort(data, size);
    System.out.println("Sorted Array in Ascending Order: ");
    System.out.println(Arrays.toString(data));
  }
}
