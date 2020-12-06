import java.io.File

data class Entry(
    val password: String,
    val letter: Char,
    val minimum: Int,
    val maximum: Int,
)

fun parseLine(line: String): Entry {
  val (range, letterWithColon, password) = line.split(' ')
  val (minimum, maximum) = range.split('-')
  val letter = letterWithColon.first()

  return Entry(password = password, letter = letter, minimum = minimum.toInt(), maximum = maximum.toInt())
}

fun Entry.isValid(): Boolean {
  return password.filter { it == letter }.length in minimum..maximum
}

val input = File("2.txt").readLines()
val entries = input.map { parseLine(it) }

val result = entries.filter { it.isValid() }.size
println(result)

fun Entry.isValid2(): Boolean {
  return (password[minimum - 1] == letter) xor (password[maximum - 1] == letter)
}

val result2 = entries.filter { it.isValid2() }.size
println(result2)
