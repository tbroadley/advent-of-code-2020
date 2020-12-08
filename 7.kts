import java.io.File

fun getBagCount(bagMap: Map<String, Map<String, Int>>, startingColour: String): Int {
  val bags = bagMap[startingColour] ?: return 0

  if (bags.isEmpty()) {
    return 0
  }

  return bags.entries.asSequence()
      .map { (colour, count) -> (getBagCount(bagMap, colour) + 1) * count }
      .sum()
}

val input = File("7.txt").readLines()
    .map { line ->
      val (colour, bagCounts) = line.split(" bags contain ")
      val bagCountMatches = "(\\d [a-z]+ [a-z]+) bags?".toRegex().findAll(bagCounts)
          .map { match ->
            val bagDescription = match.groupValues[1].split(" ")
            val bagColour = bagDescription.drop(1).joinToString(" ")
            val bagCount = bagDescription.first().toInt()
            bagColour to bagCount
          }
          .toMap()
      colour to bagCountMatches
    }
    .toMap()

println(getBagCount(input, "shiny gold"))
