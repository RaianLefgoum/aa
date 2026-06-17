%%manim -qm -v WARNING T2SComplexityExplosionSimple

from manim import *


class T2SComplexityExplosionSimple(Scene):
    def construct(self):
        self.camera.background_color = "#0b1020"

        title = Text("Why is night settlement difficult?", font_size=38)
        subtitle = Text(
            "The engine must choose which transactions should settle.",
            font_size=23,
            color=GRAY_B,
        )

        VGroup(title, subtitle).arrange(DOWN, buff=0.2).to_edge(UP)

        self.play(Write(title), FadeIn(subtitle))
        self.wait(1.5)

        section = Text(
            "Without auto-collateralisation and partial settlement",
            font_size=28,
        ).move_to(UP * 2.0)

        self.play(FadeIn(section))

        transactions = VGroup()

        for i in range(8):
            box = RoundedRectangle(
                width=0.8,
                height=0.45,
                corner_radius=0.06,
                stroke_color=YELLOW,
                stroke_width=2,
                fill_color="#1a2140",
                fill_opacity=0.9,
            )
            label = Text(f"T{i+1}", font_size=15)
            label.move_to(box)
            transactions.add(VGroup(box, label))

        transactions.arrange(RIGHT, buff=0.18).move_to(UP * 0.85)

        self.play(LaggedStart(*[FadeIn(t) for t in transactions], lag_ratio=0.08))
        self.wait(1)

        simplification = Text(
            "To understand the idea, let us simplify to only 3 transactions.",
            font_size=28,
            color=GRAY_B,
        ).move_to(DOWN * 0.25)

        self.play(FadeIn(simplification))
        self.wait(1.5)

        simple_transactions = transactions[:3].copy()
        simple_transactions.arrange(RIGHT, buff=0.5).move_to(UP * 1.05)

        self.play(
            FadeOut(transactions),
            TransformFromCopy(transactions[:3], simple_transactions),
            FadeOut(simplification),
            FadeOut(section),
        )
        self.wait(1)

        binary_explain = Text(
            "For each transaction, the engine has 2 choices:",
            font_size=27,
        ).move_to(UP * 0.15)

        choice_text = Text(
            "settle  or  wait",
            font_size=32,
            color=YELLOW,
        ).next_to(binary_explain, DOWN, buff=0.25)

        self.play(FadeIn(binary_explain), FadeIn(choice_text))
        self.wait(1.5)

        self.play(FadeOut(binary_explain), FadeOut(choice_text))

        combo_title = Text(
            "With only 3 transactions, we already have 8 possibilities:",
            font_size=27,
        ).move_to(UP * 2.05)

        self.play(FadeIn(combo_title))

        combos = [
            ("wait", "wait", "wait"),
            ("settle", "wait", "wait"),
            ("wait", "settle", "wait"),
            ("wait", "wait", "settle"),
            ("settle", "settle", "wait"),
            ("settle", "wait", "settle"),
            ("wait", "settle", "settle"),
            ("settle", "settle", "settle"),
        ]

        combo_rows = VGroup()

        for combo in combos:
            row = VGroup()

            for decision in combo:
                color = GREEN if decision == "settle" else RED

                cell = RoundedRectangle(
                    width=0.95,
                    height=0.32,
                    corner_radius=0.05,
                    stroke_color=color,
                    stroke_width=1.3,
                    fill_color="#1a2140",
                    fill_opacity=0.85,
                )

                label = Text(decision, font_size=14, color=color)
                label.move_to(cell)

                row.add(VGroup(cell, label))

            row.arrange(RIGHT, buff=0.18)
            combo_rows.add(row)

        combo_rows.arrange(DOWN, buff=0.08)
        combo_rows.next_to(simple_transactions, DOWN, buff=0.35)

        self.play(
            LaggedStart(
                *[FadeIn(row, shift=RIGHT * 0.25) for row in combo_rows],
                lag_ratio=0.12,
            )
        )
        self.wait(2)

        conclusion = MathTex(
            r"3\ \text{transactions} \Rightarrow 2 \times 2 \times 2 = 2^3 = 8",
            font_size=34,
            color=YELLOW,
        ).to_edge(DOWN)

        self.play(Write(conclusion))
        self.wait(2)

        self.play(
            FadeOut(simple_transactions),
            FadeOut(combo_title),
            FadeOut(combo_rows),
            FadeOut(conclusion),
        )

        formula2 = MathTex(
            r"N\ \text{transactions} \Rightarrow 2^N\ \text{possibilities}",
            font_size=42,
            color=YELLOW,
        ).move_to(UP * 2.3)

        self.play(Write(formula2))
        self.wait(1.5)

        examples_title = Text("How fast does it explode?", font_size=34)
        examples_title.move_to(UP * 1.45)

        self.play(FadeIn(examples_title))

        examples = VGroup(
            Text("10 transactions  →  about one thousand possibilities", font_size=28),
            Text("30 transactions  →  about one billion possibilities", font_size=28),
            Text("50 transactions  →  more than one quadrillion possibilities", font_size=28),
            Text("100 transactions →  more than one trillion trillion trillion possibilities", font_size=28),
        )

        examples.arrange(DOWN, buff=0.35).move_to(DOWN * 0.25)

        self.play(
            LaggedStart(
                *[FadeIn(e, shift=RIGHT) for e in examples],
                lag_ratio=0.25,
            )
        )
        self.wait(2.5)

        self.play(FadeOut(examples), FadeOut(examples_title), FadeOut(formula2))

        shock_title = Text(
            "Now consider only 300 transactions...",
            font_size=36,
            color=RED,
        ).move_to(UP * 1.3)

        shock_text = Text(
            "The number of possible settlement decisions\n"
            "is larger than the estimated number of atoms\n"
            "in the observable universe.",
            font_size=32,
            color=WHITE,
            line_spacing=1.15,
        ).move_to(ORIGIN)

        self.play(Write(shock_title))
        self.play(Write(shock_text))
        self.wait(3)

        comparison = Text(
            "And real settlement systems can process far more than 300 transactions.",
            font_size=27,
            color=YELLOW,
        ).to_edge(DOWN)

        self.play(FadeIn(comparison))
        self.wait(2.5)

        self.play(FadeOut(shock_title), FadeOut(shock_text), FadeOut(comparison))

        brute_force = Text(
            "The engine cannot try every possibility.",
            font_size=38,
            color=WHITE,
        )

        smart = Text(
            "It must search intelligently.",
            font_size=38,
            color=YELLOW,
        )

        VGroup(brute_force, smart).arrange(DOWN, buff=0.35).move_to(ORIGIN)

        self.play(Write(brute_force))
        self.wait(0.8)
        self.play(Write(smart))
        self.wait(2)

        self.play(FadeOut(brute_force), FadeOut(smart))

        final_title = Text(
            "With auto-collateralisation and partial settlement,\nit becomes even harder.",
            font_size=34,
            color=WHITE,
            line_spacing=1.1,
        ).move_to(UP * 1.6)

        auto = Text(
            "Auto-collateralisation adds new liquidity choices.",
            font_size=30,
            color=BLUE,
        )

        partial = Text(
            "Partial settlement makes the decision non-binary.",
            font_size=30,
            color=YELLOW,
        )

        formula_partial = MathTex(
            r"x_i \in \{0,1,\dots,q_i\}",
            font_size=42,
            color=YELLOW,
        )

        explanation = Text(
            "Instead of choosing only settle / wait,\n"
            "the engine may choose how much of a transaction settles.",
            font_size=28,
            color=GRAY_B,
            line_spacing=1.1,
        )

        final_group = VGroup(auto, partial, formula_partial, explanation)
        final_group.arrange(DOWN, buff=0.35).move_to(DOWN * 0.4)

        self.play(Write(final_title))
        self.wait(0.8)
        self.play(FadeIn(auto))
        self.wait(0.8)
        self.play(FadeIn(partial))
        self.play(Write(formula_partial))
        self.play(FadeIn(explanation))
        self.wait(3)

        end = Text(
            "This is why optimization is needed.",
            font_size=38,
            color=YELLOW,
        ).move_to(ORIGIN)

        self.play(FadeOut(final_title), FadeOut(final_group))
        self.play(Write(end))
        self.wait(3) 
