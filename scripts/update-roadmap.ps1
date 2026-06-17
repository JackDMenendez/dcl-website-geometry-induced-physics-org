<#
.SYNOPSIS
  Snapshot GitHub Project #6 into a static roadmap page for the Quarto site.

.DESCRIPTION
  Fetches the public project board (https://github.com/users/JackDMenendez/projects/6)
  via the authenticated `gh` CLI and writes:
    - roadmap.qmd         : a static markdown page, items grouped by Status
    - assets/roadmap.json : the raw board JSON, committed for provenance

  Requires `gh` authenticated with the `project` scope (read is sufficient here).
  Run from anywhere; paths resolve relative to the repo root.

  This is a LOCAL snapshot generator (Option A). Re-run it whenever you want the
  public roadmap to move, then commit roadmap.qmd + assets/roadmap.json.
#>
[CmdletBinding()]
param(
  [string]$Owner   = 'JackDMenendez',
  [int]   $Project = 6
)

$ErrorActionPreference = 'Stop'

# Repo root = parent of this script's folder.
$repoRoot = Split-Path -Parent $PSScriptRoot
$qmdPath  = Join-Path $repoRoot 'roadmap.qmd'
$jsonPath = Join-Path $repoRoot 'assets/roadmap.json'

Write-Host "Fetching project $Project (owner $Owner)..." -ForegroundColor Cyan
$raw = gh project item-list $Project --owner $Owner --format json --limit 200
if ($LASTEXITCODE -ne 0) { throw "gh failed (exit $LASTEXITCODE). Is it authed with 'project' scope? Run: gh auth status" }

# Provenance copy of the raw board.
$raw | Out-File -FilePath $jsonPath -Encoding utf8
$board = $raw | ConvertFrom-Json
$items = @($board.items)

# --- Exclude sub-issues -------------------------------------------------
# The board lists sub-issues as flat items, but this roadmap is
# subproject-level: drop any board item that is a sub-issue of another
# issue (the work-item breakdown stays on the GitHub board). The project
# item JSON does not carry the parent relation, so query it per repo via
# GraphQL. A detection failure aborts (fail-closed) rather than silently
# publishing sub-items.
$subQuery = @'
query($owner:String!, $repo:String!, $cursor:String) {
  repository(owner:$owner, name:$repo) {
    issues(first:100, after:$cursor, states:[OPEN, CLOSED]) {
      pageInfo { hasNextPage endCursor }
      nodes { number parent { number } }
    }
  }
}
'@
$subIssueKeys = [System.Collections.Generic.HashSet[string]]::new()
$repos = $items |
  Where-Object { $_.content -and $_.content.repository } |
  ForEach-Object { $_.content.repository } | Select-Object -Unique
foreach ($r in $repos) {
  $parts = $r -split '/', 2
  if ($parts.Count -ne 2) { continue }
  $owner2, $name2 = $parts
  $cursor = $null
  do {
    $ghArgs = @('api', 'graphql', '-f', "query=$subQuery", '-f', "owner=$owner2", '-f', "repo=$name2")
    if ($cursor) { $ghArgs += @('-f', "cursor=$cursor") }
    $resp = (& gh @ghArgs | ConvertFrom-Json)
    if ($LASTEXITCODE -ne 0) { throw "gh GraphQL sub-issue query failed for $r (exit $LASTEXITCODE)." }
    $conn = $resp.data.repository.issues
    foreach ($n in $conn.nodes) { if ($n.parent) { [void]$subIssueKeys.Add("$r#$($n.number)") } }
    $cursor = if ($conn.pageInfo.hasNextPage) { $conn.pageInfo.endCursor } else { $null }
  } while ($cursor)
}
$before = $items.Count
$items = @($items | Where-Object {
  -not ($_.content -and $_.content.type -eq 'Issue' -and
        $subIssueKeys.Contains("$($_.content.repository)#$($_.content.number)"))
})
$hidden = $before - $items.Count
if ($hidden -gt 0) {
  Write-Host "Filtered $hidden sub-issue(s) from the roadmap (still tracked on the board)." -ForegroundColor Yellow
}

$generated = (Get-Date).ToString('yyyy-MM-dd')

function Format-Cell([string]$s) {
  if ($null -eq $s) { return '' }
  # Escape pipes and collapse newlines so a value stays inside one table cell.
  ($s -replace '\|', '\|') -replace '\r?\n', ' '
}

function Format-Milestone($m) {
  if (-not $m) { return '—' }
  $t = Format-Cell $m.title
  if ($m.dueOn) {
    $due = ([datetime]$m.dueOn).ToString('yyyy-MM-dd')
    return "$t (due $due)"
  }
  return $t
}

function Format-Group([string]$status, $rows) {
  $sb = [System.Text.StringBuilder]::new()
  [void]$sb.AppendLine("## $status ($($rows.Count))")
  [void]$sb.AppendLine()
  if ($rows.Count -eq 0) {
    [void]$sb.AppendLine('_No items._')
    [void]$sb.AppendLine()
    return $sb.ToString()
  }
  [void]$sb.AppendLine('| Item | Milestone | Labels |')
  [void]$sb.AppendLine('|------|-----------|--------|')
  foreach ($it in $rows) {
    $title = Format-Cell $it.title
    $url   = if ($it.content -and $it.content.url) { $it.content.url } else { $null }
    $item  = if ($url) { "[$title]($url)" } else { $title }
    $ms    = Format-Milestone $it.milestone
    $lbls  = if ($it.labels) { Format-Cell ((@($it.labels)) -join ', ') } else { '—' }
    [void]$sb.AppendLine("| $item | $ms | $lbls |")
  }
  [void]$sb.AppendLine()
  return $sb.ToString()
}

# Status display order: active first, then queued, then finished.
# Any status not listed here is appended afterwards so nothing is silently dropped.
$order = @('In Progress', 'Todo', 'Done')
$present = $items | ForEach-Object { if ($_.status) { $_.status } else { 'No status' } } |
           Select-Object -Unique
$ordered = @($order | Where-Object { $present -contains $_ }) +
           @($present | Where-Object { $order -notcontains $_ } | Sort-Object)

$total = $items.Count
$summaryParts = foreach ($s in $ordered) {
  $c = @($items | Where-Object { (($_.status) ? $_.status : 'No status') -eq $s }).Count
  "**$c** $s"
}
$summary = $summaryParts -join ' · '

$body = [System.Text.StringBuilder]::new()
[void]$body.AppendLine('---')
[void]$body.AppendLine('title: "Project roadmap"')
[void]$body.AppendLine('subtitle: "Operational status of the A=1 Discrete Causal Lattice subprojects"')
[void]$body.AppendLine("date: $generated")
[void]$body.AppendLine('date-format: iso')
[void]$body.AppendLine('---')
[void]$body.AppendLine()
[void]$body.AppendLine('::: {.callout-note appearance="simple"}')
[void]$body.AppendLine("Snapshot of the public [project board](https://github.com/users/$Owner/projects/$Project), " +
                       "generated **$generated**. $total items: $summary.")
[void]$body.AppendLine('')
[void]$body.AppendLine('This tracks *operational* status of the subprojects. For the status of ' +
                       'individual scientific *claims*, see the [claim map](papers/claim-map.qmd).')
[void]$body.AppendLine(':::')
[void]$body.AppendLine()

foreach ($s in $ordered) {
  $rows = @($items | Where-Object { (($_.status) ? $_.status : 'No status') -eq $s })
  [void]$body.Append((Format-Group $s $rows))
}

[void]$body.AppendLine('---')
[void]$body.AppendLine()
[void]$body.AppendLine("*Generated from the GitHub project board by ``scripts/update-roadmap.ps1`` on $generated. " +
                       "Do not edit this file by hand — re-run the script.*")

$body.ToString() | Out-File -FilePath $qmdPath -Encoding utf8

Write-Host "Wrote $qmdPath" -ForegroundColor Green
Write-Host "Wrote $jsonPath" -ForegroundColor Green
Write-Host "Summary: $total items — $summary" -ForegroundColor Green
