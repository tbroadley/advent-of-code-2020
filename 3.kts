import java.io.File

val input = File("3.txt").readLines()
val treeCount = input.withIndex()
    .filter { (index, line) -> line[(index * 3) % line.length] == '#' }
    .size
println(treeCount)

val result2 = listOf(
    1 to 1,
    3 to 1,
    5 to 1,
    7 to 1,
    1 to 2,
)
    .map { (right, down) ->
      input.withIndex()
          .filter { (index, line) ->
            if (index % down != 0) return@filter false

            line[(index * right / down) % line.length] == '#'
          }
          .size
          .toLong()
    }
    .reduce { acc, i -> acc * i }
println(result2)
