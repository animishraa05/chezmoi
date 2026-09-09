#!/usr/bin/env python3
"""
Pomodoro Stats TUI — by ani
Textual-based dashboard for daily, weekly, and monthly focus tracking.
"""
import csv
import datetime
import calendar
from pathlib import Path
from collections import defaultdict
from typing import Sequence

from textual.app import App, ComposeResult
from textual.binding import Binding
from textual.containers import Container, Horizontal, Vertical, VerticalScroll
from textual.widgets import Label, Button, Sparkline, DataTable, Rule, Footer, Header
from textual.reactive import reactive

CSV_PATH = Path.home() / ".local" / "share" / "pomodoro_history.csv"

# ─── Color palette (Catppuccin Mocha) ─────────────────────────────────────────
C_BASE    = "#1e1e2e"
C_MANTLE  = "#181825"
C_CRUST   = "#11111b"
C_SURFACE0= "#313244"
C_SURFACE1= "#45475a"
C_OVERLAY = "#6c7086"
C_TEXT    = "#cdd6f4"
C_SUBTEXT = "#bac2de"
C_BLUE    = "#89b4fa"
C_LAVENDER= "#b4befe"
C_GREEN   = "#a6e3a1"
C_YELLOW  = "#f9e2af"
C_PEACH   = "#fab387"
C_RED     = "#f38ba8"
C_MAUVE   = "#cba6f7"
C_TEAL    = "#94e2d5"
C_SKY     = "#89dceb"


# ─── Data helpers ──────────────────────────────────────────────────────────────

def load_data():
    """Load all pomodoro sessions from the CSV log."""
    data = []
    if CSV_PATH.exists():
        with open(CSV_PATH, "r") as f:
            for row in csv.reader(f):
                if len(row) >= 3:
                    try:
                        dt       = datetime.datetime.fromisoformat(row[0])
                        duration = int(row[1])
                        ptype    = row[2].strip()
                        if duration > 0:
                            data.append({"dt": dt, "duration": duration, "type": ptype})
                    except (ValueError, IndexError):
                        pass
    return data


def fmt_duration(seconds: int) -> str:
    """Human-readable duration, e.g. '1h 25m' or '45m'."""
    m = seconds // 60
    h, m = divmod(m, 60)
    if h:
        return f"{h}h {m}m"
    return f"{m}m"


def heat_class(minutes: int) -> str:
    """Return CSS class based on focus intensity."""
    if   minutes == 0:   return "zero"
    elif minutes <= 30:  return "heat1"
    elif minutes <= 60:  return "heat2"
    elif minutes <= 120: return "heat3"
    else:                return "heat4"


# ─── Views ─────────────────────────────────────────────────────────────────────

class TodayView(VerticalScroll):
    """24-hour timeline and session list for today."""

    def __init__(self, data):
        super().__init__()
        self.data = data

    def compose(self) -> ComposeResult:
        today      = datetime.datetime.now().date()
        today_data = [d for d in self.data if d["dt"].date() == today]

        total_s    = sum(d["duration"] for d in today_data)
        session_ct = len(today_data)

        yield Label(f"🍅  Today — {datetime.date.today().strftime('%A, %d %B %Y')}", classes="view-title")
        yield Rule(line_style="heavy")

        # Summary row
        with Horizontal(classes="stats-row"):
            yield Label(f"Total Focus\n[bold]{fmt_duration(total_s)}[/]",   classes="stat-card")
            yield Label(f"Sessions\n[bold]{session_ct}[/]",                  classes="stat-card")
            avg = (total_s // session_ct // 60) if session_ct else 0
            yield Label(f"Avg Session\n[bold]{avg}m[/]",                     classes="stat-card")

        yield Rule()

        if not today_data:
            yield Label("\n  No sessions logged yet today. Start a Pomodoro! 🚀", classes="empty-msg")
            return

        # ASCII 24h timeline  (each char = 30 min block)
        yield Label("  24-Hour Timeline (each block = 30 min)", classes="section-title")
        timeline = ["░"] * 48  # 48 × 30min = 24h
        for d in today_data:
            end   = d["dt"]
            start = end - datetime.timedelta(seconds=d["duration"])
            s_idx = max(0, int((start.hour * 60 + start.minute) // 30))
            e_idx = min(47, int((end.hour * 60 + end.minute) // 30))
            for i in range(s_idx, e_idx + 1):
                timeline[i] = "█"

        hour_labels = "".join(
            f"{h:02d}" if h % 3 == 0 else "  "
            for h in range(0, 24)
        )
        bar = "".join(timeline)
        yield Label(f"  [dim]{hour_labels}[/]", classes="timeline-hours")
        yield Label(f"  [{C_MAUVE}]{bar}[/]",   classes="timeline-bar")

        yield Rule()
        yield Label("  Session Log", classes="section-title")

        table = DataTable(cursor_type="row")
        table.add_columns("#", "Start", "End", "Duration", "Status")
        for idx, d in enumerate(today_data, 1):
            end   = d["dt"]
            start = end - datetime.timedelta(seconds=d["duration"])
            dur_m = d["duration"] // 60
            read_dur = f"{dur_m}m"

            # Determine if full or partial
            # We can't know the original planned duration from the log alone,
            # so we just show "Work" uniformly
            table.add_row(
                str(idx),
                start.strftime("%H:%M"),
                end.strftime("%H:%M"),
                read_dur,
                f"[{C_GREEN}]Work[/]",
            )
        yield table


class WeeklyView(VerticalScroll):
    """Sparkline bar chart per day for the current week."""

    def __init__(self, data):
        super().__init__()
        self.data = data

    def compose(self) -> ComposeResult:
        today         = datetime.datetime.now().date()
        start_of_week = today - datetime.timedelta(days=today.weekday())

        week_mins = defaultdict(int)
        for d in self.data:
            day = d["dt"].date()
            if start_of_week <= day < start_of_week + datetime.timedelta(days=7):
                if d["type"] == "work":
                    week_mins[day] += d["duration"] // 60

        yield Label(f"📊  Week of {start_of_week.strftime('%d %b')} – {(start_of_week + datetime.timedelta(6)).strftime('%d %b %Y')}", classes="view-title")
        yield Rule(line_style="heavy")

        days      = [start_of_week + datetime.timedelta(days=i) for i in range(7)]
        spark_dat = [float(week_mins[d]) for d in days]
        total_m   = int(sum(spark_dat))
        best_day  = days[spark_dat.index(max(spark_dat))] if any(v > 0 for v in spark_dat) else None

        with Horizontal(classes="stats-row"):
            yield Label(f"Week Total\n[bold]{total_m // 60}h {total_m % 60}m[/]", classes="stat-card")
            yield Label(f"Best Day\n[bold]{best_day.strftime('%A') if best_day else '—'}[/]", classes="stat-card")
            days_active = sum(1 for v in spark_dat if v > 0)
            yield Label(f"Active Days\n[bold]{days_active} / 7[/]", classes="stat-card")

        yield Rule()

        if not any(v > 0 for v in spark_dat):
            yield Label("\n  No focus sessions this week yet.", classes="empty-msg")
        else:
            yield Label("  Focus minutes per day", classes="section-title")
            yield Sparkline(spark_dat, summary_function=max,
                            min_color=C_TEAL, max_color=C_MAUVE)

        # Day labels aligned under sparkline
        day_labels = "   ".join(
            f"[bold {C_YELLOW}]{d.strftime('%a')}[/]" if d == today else d.strftime("%a")
            for d in days
        )
        yield Label(f"\n  {day_labels}", classes="axis-label")

        yield Rule()
        yield Label("  Daily Breakdown", classes="section-title")

        table = DataTable(cursor_type="row")
        table.add_columns("Day", "Date", "Focus Time", "Sessions", "Intensity")
        for d in days:
            mins     = week_mins[d]
            sessions = sum(1 for s in self.data
                           if s["dt"].date() == d and s["type"] == "work")
            intensity = ("🔥 High" if mins > 120
                         else "🟡 Medium" if mins > 60
                         else "🟢 Low" if mins > 0
                         else "⬛ Rest")
            label = f"[bold {C_YELLOW}]{d.strftime('%A')}[/]" if d == today else d.strftime("%A")
            table.add_row(label, d.strftime("%d %b"), fmt_duration(mins * 60), str(sessions), intensity)
        yield table


class MonthlyView(VerticalScroll):
    """Calendar heatmap for the current month."""

    def __init__(self, data):
        super().__init__()
        self.data = data

    def compose(self) -> ComposeResult:
        today       = datetime.datetime.now().date()
        year, month = today.year, today.month

        daily_mins = defaultdict(int)
        for d in self.data:
            if d["dt"].year == year and d["dt"].month == month and d["type"] == "work":
                daily_mins[d["dt"].day] += d["duration"] // 60

        yield Label(f"📅  {calendar.month_name[month]} {year}", classes="view-title")
        yield Rule(line_style="heavy")

        total_m   = sum(daily_mins.values())
        active_d  = len([v for v in daily_mins.values() if v > 0])
        best_mins = max(daily_mins.values()) if daily_mins else 0

        with Horizontal(classes="stats-row"):
            yield Label(f"Month Total\n[bold]{fmt_duration(total_m * 60)}[/]",        classes="stat-card")
            yield Label(f"Active Days\n[bold]{active_d}[/]",                          classes="stat-card")
            yield Label(f"Best Day\n[bold]{fmt_duration(best_mins * 60)}[/]",         classes="stat-card")

        yield Rule()

        # Legend
        with Horizontal(classes="legend-row"):
            yield Label(f"[{C_SURFACE1}]░[/] 0m", classes="legend-item")
            yield Label(f"[{C_TEAL}]▓[/] ≤30m",   classes="legend-item")
            yield Label(f"[{C_GREEN}]▓[/] ≤60m",  classes="legend-item")
            yield Label(f"[{C_YELLOW}]▓[/] ≤2h",   classes="legend-item")
            yield Label(f"[{C_RED}]▓[/] >2h",      classes="legend-item")

        yield Rule()

        # Calendar header
        header_line = "  " + "  ".join(
            f"[bold {C_SKY}]{n:^5}[/]"
            for n in ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        )
        yield Label(header_line, classes="cal-header-row")

        # Calendar rows — pure text, avoids Grid/mount issues
        cal = calendar.monthcalendar(year, month)
        for week in cal:
            cells = []
            for day in week:
                if day == 0:
                    cells.append("     ")
                else:
                    mins  = daily_mins[day]
                    hc    = heat_class(mins)
                    color = {
                        "zero":  C_SURFACE1,
                        "heat1": C_TEAL,
                        "heat2": C_GREEN,
                        "heat3": C_YELLOW,
                        "heat4": C_RED,
                    }[hc]
                    char  = "░" if mins == 0 else "█"
                    mark  = "*" if day == today.day else " "
                    cells.append(f"[{color}]{char} {day:02d}{mark}[/]")
            yield Label("  " + "  ".join(cells), classes="cal-week-row")

        yield Rule()
        yield Label("  Day-by-Day Log", classes="section-title")

        table = DataTable(cursor_type="row")
        table.add_columns("Date", "Day", "Focus Time")
        for day_num in sorted(daily_mins.keys()):
            mins = daily_mins[day_num]
            if mins > 0:
                d = datetime.date(year, month, day_num)
                marker = " ← today" if d == today else ""
                table.add_row(
                    d.strftime("%d %b"),
                    d.strftime("%A") + marker,
                    fmt_duration(mins * 60),
                )
        yield table


# ─── Main App ──────────────────────────────────────────────────────────────────

class PomodoroStatsApp(App):
    """Pomodoro Stats Dashboard."""

    TITLE = "🍅 Pomodoro Stats"

    CSS = f"""
    Screen {{
        layout: horizontal;
        background: {C_BASE};
    }}

    /* ── Sidebar ────────────────────────────────── */
    #sidebar {{
        width: 22;
        background: {C_MANTLE};
        padding: 1 1;
        border-right: solid {C_SURFACE0};
    }}

    .sidebar-logo {{
        text-align: center;
        color: {C_MAUVE};
        text-style: bold;
        padding: 1 0;
        margin-bottom: 1;
    }}

    .nav-btn {{
        width: 100%;
        margin-bottom: 1;
        background: {C_SURFACE0};
        color: {C_TEXT};
        border: none;
    }}

    .nav-btn:hover {{
        background: {C_SURFACE1};
    }}

    .nav-btn.-active {{
        background: {C_BLUE};
        color: {C_CRUST};
        text-style: bold;
    }}

    .quit-btn {{
        width: 100%;
        background: {C_SURFACE0};
        color: {C_RED};
        border: none;
        margin-top: 1;
    }}

    .quit-btn:hover {{
        background: {C_RED};
        color: {C_CRUST};
    }}

    .refresh-btn {{
        width: 100%;
        background: {C_SURFACE0};
        color: {C_GREEN};
        border: none;
        margin-top: 1;
    }}

    .refresh-btn:hover {{
        background: {C_GREEN};
        color: {C_CRUST};
    }}

    /* ── Content area ──────────────────────────── */
    #content-area {{
        width: 1fr;
        padding: 1 3;
        background: {C_BASE};
    }}

    /* ── Shared view styles ────────────────────── */
    .view-title {{
        text-style: bold;
        color: {C_BLUE};
        margin-bottom: 1;
    }}

    .section-title {{
        color: {C_GREEN};
        text-style: bold;
        margin-top: 1;
        margin-bottom: 1;
    }}

    .empty-msg {{
        color: {C_OVERLAY};
        text-style: italic;
        margin-top: 2;
    }}

    /* ── Stat cards ────────────────────────────── */
    .stats-row {{
        height: 5;
        margin-bottom: 1;
    }}

    .stat-card {{
        background: {C_MANTLE};
        border: solid {C_SURFACE0};
        padding: 0 2;
        margin-right: 2;
        color: {C_SUBTEXT};
        text-align: center;
        min-width: 18;
    }}

    /* ── Timeline ──────────────────────────────── */
    .timeline-hours {{
        color: {C_OVERLAY};
        margin-top: 1;
    }}

    .timeline-bar {{
        margin-bottom: 1;
    }}

    /* ── Sparkline ─────────────────────────────── */
    Sparkline {{
        height: 8;
        margin: 1 0;
    }}

    .axis-label {{
        color: {C_SUBTEXT};
        margin-bottom: 1;
    }}

    /* ── Calendar ──────────────────────────────── */
    .legend-row {{
        height: 3;
        margin-bottom: 1;
    }}

    .legend-item {{
        margin-right: 3;
        color: {C_SUBTEXT};
    }}

    .cal-header-row {{
        color: {C_SKY};
        text-style: bold;
        margin-bottom: 1;
    }}

    .cal-week-row {{
        margin-bottom: 0;
    }}

    /* ── DataTable ─────────────────────────────── */
    DataTable {{
        margin-top: 1;
        height: auto;
        background: {C_MANTLE};
        border: solid {C_SURFACE0};
    }}

    DataTable > .datatable--header {{
        background: {C_SURFACE0};
        color: {C_BLUE};
        text-style: bold;
    }}

    DataTable > .datatable--cursor {{
        background: {C_SURFACE1};
    }}
    """

    BINDINGS = [
        Binding("1",       "view_today",   "Today",   show=True),
        Binding("2",       "view_weekly",  "Weekly",  show=True),
        Binding("3",       "view_monthly", "Monthly", show=True),
        Binding("r",       "refresh",      "Refresh", show=True),
        Binding("q",       "quit",         "Quit",    show=True),
        Binding("ctrl+c",  "quit",         "",        show=False),
    ]

    current_view: reactive[str] = reactive("today")

    def compose(self) -> ComposeResult:
        self.data = load_data()

        with Container(id="sidebar"):
            yield Label("🍅\nPOMO\nSTATS", classes="sidebar-logo")
            yield Rule(line_style="heavy")
            yield Button("1  Today",   id="btn_today",   classes="nav-btn -active")
            yield Button("2  Weekly",  id="btn_weekly",  classes="nav-btn")
            yield Button("3  Monthly", id="btn_monthly", classes="nav-btn")
            yield Rule()
            yield Button("R  Refresh", id="btn_refresh", classes="refresh-btn")
            yield Button("Q  Quit",    id="btn_quit",    classes="quit-btn")

        with Container(id="content-area"):
            yield TodayView(self.data)

        yield Footer()

    # ── Navigation helpers ──────────────────────────────────────────────────

    def _switch_view(self, view_id: str) -> None:
        """Swap content-area child and update sidebar active state."""
        # Mark active button
        for btn in self.query(".nav-btn"):
            btn.remove_class("-active")
        try:
            self.query_one(f"#btn_{view_id}").add_class("-active")
        except Exception:
            pass

        content = self.query_one("#content-area")
        # Collect children first to avoid mutation-during-iteration
        children = list(content.children)
        for child in children:
            child.remove()

        view_map = {
            "today":   TodayView,
            "weekly":  WeeklyView,
            "monthly": MonthlyView,
        }
        content.mount(view_map[view_id](self.data))
        self.current_view = view_id

    # ── Action handlers (keyboard) ──────────────────────────────────────────

    def action_view_today(self)   -> None: self._switch_view("today")
    def action_view_weekly(self)  -> None: self._switch_view("weekly")
    def action_view_monthly(self) -> None: self._switch_view("monthly")

    def action_refresh(self) -> None:
        self.data = load_data()
        self._switch_view(self.current_view)
        self.notify("Data refreshed!", severity="information")

    def action_quit(self) -> None:
        self.exit()

    # ── Button handler ──────────────────────────────────────────────────────

    def on_button_pressed(self, event: Button.Pressed) -> None:
        id_map = {
            "btn_today":   "today",
            "btn_weekly":  "weekly",
            "btn_monthly": "monthly",
        }
        if event.button.id == "btn_quit":
            self.exit()
        elif event.button.id == "btn_refresh":
            self.action_refresh()
        elif event.button.id in id_map:
            self._switch_view(id_map[event.button.id])


if __name__ == "__main__":
    PomodoroStatsApp().run()
