import _19.RuleDefinition.Expansion
import _19.RuleDefinition.Literal
import java.io.File
import kotlin.time.measureTime

sealed class RuleDefinition {
  data class Literal(val char: Char) : RuleDefinition()
  data class Expansion(val definitions: List<List<Int>>) : RuleDefinition()
}

typealias Expansions = Map<Int, Expansion>
typealias Literals = Map<Int, Literal>

fun matches(expansions: Expansions, literals: Literals, ruleNumber: Int, message: String): Boolean {
  val map = mutableMapOf<Triple<Int, Int, Int>, Boolean>().withDefault { false }
  val len = message.length

  for (s in 1..len) {
    for ((ruleNum, rule) in literals) {
      if (rule !is Literal || rule.char != message[s - 1]) continue

      map[Triple(1, s, ruleNum)] = true
    }
  }

  for (l in 2..len) {
    for (s in 1..(len - l + 1)) {
      for ((ruleNum, rule) in expansions) {
        map[Triple(l, s, ruleNum)] = rule.definitions.any { definition ->
          if (definition.size == 1) {
            return@any map.getValue(Triple(l, s, definition[0]))
          }

          (1..(l - 1)).any { p ->
            map.getValue(Triple(p, s, definition[0])) &&
                map.getValue(Triple(l - p, s + p, definition[1]))
          }
        }
      }
    }
  }

  return map.getValue(Triple(len, 1, ruleNumber))
}

fun parseRule(line: String): Pair<Int, RuleDefinition> {
  val (ruleNumberString, ruleDefinition) = line.split(": ")
  val ruleNumber = ruleNumberString.toInt()
  if (ruleDefinition.startsWith("\"")) return ruleNumber to Literal(ruleDefinition[1])

  val definitions = ruleDefinition.split(" | ")
      .map { lr -> lr.split(" ").map { it.toInt() } }
  return ruleNumber to Expansion(definitions)
}

val input = File("19.txt").readLines()
val emptyLineIndex = input.indexOf("")

val rules = input.take(emptyLineIndex).map { parseRule(it) }.toMap()
val expansions = rules.filter { it.value is Expansion } as Expansions
val literals = rules.filter { it.value is Literal } as Literals

val messages = input.drop(emptyLineIndex + 1)

val part1Result = messages.parallelStream()
    .filter { message ->
      var result: Boolean

      @OptIn(kotlin.time.ExperimentalTime::class)
      val duration = measureTime { result = matches(expansions, literals, 0, message) }

      println("${message.length} ${duration}")
      result
    }
    .count()
println("Part 1: $part1Result")

