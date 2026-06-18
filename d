%%manim -qm T2SKeyStatistics

from manim import *

class T2SKeyStatistics(Scene):
    def construct(self):
        self.camera.background_color = "#0b1020"

        title = Text("T2S Settlement Key Statistics", font_size=40, weight=BOLD)
        title.to_edge(UP)

        subtitle = Text(
            "Overall settlement activity and Night-Time Settlement",
            font_size=24,
            color=GREY_B
        )
        subtitle.next_to(title, DOWN, buff=0.25)

        self.play(Write(title), FadeIn(subtitle, shift=DOWN * 0.2))

        stats = [
            ("Average daily transactions\nin T2S", "~700,000", "transactions / day", BLUE),
            ("Average daily transactions\nin NTS", "~420,000", "transactions / day", PURPLE),
            ("Settlement value\nin T2S", "~€2.2T", "settled / day", YELLOW),
            ("Settlement ratio\n(volume)", "98.0%", "transactions settled", GREEN),
            ("Settlement ratio\n(value)", "99.1%", "euro value settled", GREEN),
            ("Average execution time", "1.6 s", "per transaction", PURPLE),
        ]

        cards = VGroup()
        for label, value, unit, color in stats:
            cards.add(self.metric_card(label, value, unit, color))

        cards.arrange_in_grid(rows=2, cols=3, buff=0.35)
        cards.move_to(DOWN * 0.35)

        self.play(
            LaggedStart(
                *[FadeIn(card[0], shift=UP * 0.2) for card in cards],
                lag_ratio=0.12
            )
        )

        self.play(
            LaggedStart(
                *[
                    AnimationGroup(
                        FadeIn(card[1], shift=DOWN * 0.15),
                        FadeIn(card[2], scale=0.8),
                        FadeIn(card[3], shift=UP * 0.15),
                    )
                    for card in cards
                ],
                lag_ratio=0.18
            )
        )

        self.wait(2)

    def metric_card(self, label, value, unit, color):
        box = RoundedRectangle(
            width=3.75,
            height=2.35,
            corner_radius=0.18,
            color=color,
            fill_opacity=0.12
        )

        label_text = Text(
            label,
            font_size=20,
            line_spacing=0.8,
            color=WHITE
        )
        label_text.next_to(box.get_top(), DOWN, buff=0.25)

        value_text = Text(
            value,
            font_size=38,
            weight=BOLD,
            color=color
        )
        value_text.move_to(box.get_center() + DOWN * 0.1)

        unit_text = Text(
            unit,
            font_size=18,
            color=GREY_B
        )
        unit_text.next_to(value_text, DOWN, buff=0.18)

        return VGroup(box, label_text, value_text, unit_text)
