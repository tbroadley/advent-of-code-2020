import java.io.File

val input = File("1.txt").readLines().map { it.toInt() }

outer@ for ((index1, number1) in input.withIndex()) {
  for ((index2, number2) in input.withIndex()) {
    if (index1 == index2) continue

    if (number1 + number2 == 2020) {
      println(number1 * number2)
      break@outer
    }
  }
}

outer@ for ((index1, number1) in input.withIndex()) {
  for ((index2, number2) in input.withIndex()) {
    for ((index3, number3) in input.withIndex()) {
      if (index1 == index2 || index1 == index3 || index2 == index3) continue

      if (number1 + number2 + number3 == 2020) {
        println(number1 * number2 * number3)
        break@outer
      }
    }
  }
}
