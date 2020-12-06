import java.io.File

data class Seat(
    val row: Int,
    val column: Int,
) {
  fun id(): Int = row * 8 + column
}

fun String.toSeat(): Seat {
  check(length == 10)

  val row = take(7).replace('F', '0').replace('B', '1').toInt(radix = 2)
  val column = takeLast(3).replace('L', '0').replace('R', '1').toInt(radix = 2)

  return Seat(row = row, column = column)
}

val input = File("5.txt").readLines()
val result = input.maxOf { it.toSeat().id() }
println(result)

val seatIds = input.map { it.toSeat().id() }
val result2 = (seatIds.minOrNull()!!..seatIds.maxOrNull()!!).sum() - seatIds.sum()
println(result2)
