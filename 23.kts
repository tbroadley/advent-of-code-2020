fun step(numbers: List<Int>): List<Int> {
  val current = numbers.first()
  val next = numbers.subList(1, 4)
  val remaining = numbers.subList(4, numbers.size)

  val destination = ((current - 1) downTo (current - numbers.size))
      .filterNot { it == 0 }
      .map {
        val rem = it.rem(10)
        if (rem < 0) rem + 10 else rem
      }
      .subtract(next)
      .first()

  val insertAt = remaining.indexOf(destination) + 1
  return remaining.subList(0, insertAt) +
      next +
      remaining.subList(insertAt, remaining.size) +
      listOf(current)
}

var input = "952438716".toCharArray().map { it.toString().toInt() }

repeat(100) {
  input = step(input)
}

val indexOfOne = input.indexOf(1)
val rotated = input.subList(indexOfOne + 1, input.size) +
    input.subList(0, indexOfOne)
val answer = rotated.joinToString("").toInt()
println(answer)
