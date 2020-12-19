import _19part2.RuleDefinition.Expansion
import _19part2.RuleDefinition.Literal
import java.io.File
import kotlin.time.measureTime

sealed class RuleDefinition {
  data class Literal(val char: Char?) : RuleDefinition()
  data class Expansion(val definitions: List<List<Int>>) : RuleDefinition()
}

typealias Expansions = MutableMap<Int, Expansion>
typealias Literals = MutableMap<Int, Literal>

fun matches(expansions: Expansions, literals: Literals, ruleNumber: Int, message: String): Boolean {
  val map = mutableMapOf<Triple<Int, Int, Int>, Boolean>().withDefault { false }
  val len = message.length

  for (s in message.indices) {
    for ((ruleNum, rule) in literals) {
      map[Triple(1, s, ruleNum)] = rule.char == null || rule.char == message[s]
    }
  }

  for (l in 2..len) {
    for (s in 0..(len - l)) {
      for ((ruleNum, rule) in expansions) {
        map[Triple(l, s, ruleNum)] = rule.definitions.any { definition ->
          if (definition.size != 2) println("$ruleNum, $definition, ${definition.size}")
          check(definition.size == 2)

          (1..(l - 1)).any { p ->
            map.getValue(Triple(p, s, definition[0])) &&
                map.getValue(Triple(l - p, s + p, definition[1]))
          }
        }
      }
    }
  }

  return map.getValue(Triple(len, 0, ruleNumber))
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

val rule42 = expansions.getValue(42).definitions
expansions[8] = Expansion(definitions = listOf(listOf(42, 8)) + rule42) // To handle the rule "8: 42 | 42 8"

// To handle the rule "38: 20 | 39"
expansions.remove(38)
literals[38] = Literal(char = null)

// To handle the rule "11: 42 31 | 42 11 31"
expansions[12340000] = Expansion(definitions = listOf(listOf(11, 31)))
expansions[11] = Expansion(definitions = listOf(listOf(42, 31), listOf(42, 12340000)))

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

