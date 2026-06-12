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
                width=1.05,
                height=0.55,
                corner_radius=0.08,
                stroke_color=YELLOW,
                stroke_width=2,
                fill_color="#1a2140",
                fill_opacity=0.9,
            )
            label = Text(f"T{i+1}", font_size=18)
            label.move_to(box)
            transactions.add(VGroup(box, label))

        transactions.arrange(RIGHT, buff=0.25).move_to(UP * 0.85)

        self.play(LaggedStart(*[FadeIn(t) for t in transactions], lag_ratio=0.08))

        choices = VGroup()

        for t in transactions:
            settle = Text("settle", font_size=16, color=GREEN)
            wait = Text("wait", font_size=16, color=RED)
            pair = VGroup(settle, wait).arrange(DOWN, buff=0.08)
            pair.next_to(t, DOWN, buff=0.22)
            choices.add(pair)

        self.play(LaggedStart(*[FadeIn(c) for c in choices], lag_ratio=0.08))
        self.wait(1)

        formula1 = MathTex(
            r"\text{Each transaction is binary: settle or wait}",
            font_size=34,
        )

        formula2 = MathTex(
            r"\text{Number of possible subsets} = 2^N",
            font_size=44,
            color=YELLOW,
        )

        VGroup(formula1, formula2).arrange(DOWN, buff=0.35).move_to(DOWN * 1.5)

        self.play(Write(formula1))
        self.play(Write(formula2))
        self.wait(2)

        self.play(
            FadeOut(section),
            FadeOut(transactions),
            FadeOut(choices),
            FadeOut(formula1),
            formula2.animate.move_to(UP * 2.3),
        )

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

        self.play(LaggedStart(*[FadeIn(e, shift=RIGHT) for e in examples], lag_ratio=0.25))
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
