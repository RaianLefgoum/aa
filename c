%%manim -qm -v WARNING MathematicalOptimizationIntro

from manim import *
import random


class MathematicalOptimizationIntro(Scene):
    def construct(self):
        self.camera.background_color = "#0b1020"

        title = Text("Mathematical Optimization", font_size=42)
        subtitle = Text(
            "A way to make the best possible decision under constraints",
            font_size=24,
            color=GRAY_B,
        )
        VGroup(title, subtitle).arrange(DOWN, buff=0.25).to_edge(UP)

        self.play(Write(title), FadeIn(subtitle))
        self.wait(2)

        # What is optimization?
        question = Text("What is it?", font_size=36, color=YELLOW).move_to(UP * 1.4)

        answer = Text(
            "Optimization is about choosing the best decision\n"
            "among many possible decisions.",
            font_size=30,
            color=WHITE,
            line_spacing=1.15,
        ).move_to(ORIGIN)

        examples = Text(
            "Examples: minimize cost, maximize settlement,\n"
            "reduce delay, allocate resources efficiently.",
            font_size=26,
            color=GRAY_B,
            line_spacing=1.1,
        ).move_to(DOWN * 1.5)

        self.play(FadeOut(subtitle), FadeIn(question))
        self.play(Write(answer))
        self.play(FadeIn(examples))
        self.wait(3)
        self.play(FadeOut(question), FadeOut(answer), FadeOut(examples))

        # Real-world to model
        real_world = Text("Real-world problem", font_size=32, color=WHITE)
        math_model = Text("Mathematical model", font_size=32, color=YELLOW)

        real_box = RoundedRectangle(width=4.3, height=2.2, corner_radius=0.15,
                                    stroke_color=WHITE, fill_color="#111832", fill_opacity=0.9)
        math_box = RoundedRectangle(width=4.3, height=2.2, corner_radius=0.15,
                                    stroke_color=YELLOW, fill_color="#111832", fill_opacity=0.9)

        real_group = VGroup(real_box, real_world).move_to(LEFT * 3)
        math_group = VGroup(math_box, math_model).move_to(RIGHT * 3)

        arrow = Arrow(real_group.get_right(), math_group.get_left(), buff=0.4, color=YELLOW)

        caption = Text(
            "Before solving, we must translate the business problem\n"
            "into variables, objectives, and constraints.",
            font_size=27,
            color=GRAY_B,
            line_spacing=1.1,
        ).to_edge(DOWN)

        self.play(FadeIn(real_group))
        self.play(GrowArrow(arrow), FadeIn(math_group))
        self.play(FadeIn(caption))
        self.wait(3)
        self.play(FadeOut(real_group), FadeOut(math_group), FadeOut(arrow), FadeOut(caption))

        # Example formulation
        formulation_title = Text("Example formulation", font_size=36, color=YELLOW).to_edge(UP)

        intro = Text(
            "Suppose each transaction can either settle or wait.",
            font_size=27,
            color=WHITE,
        ).move_to(UP * 1.8)

        variable = MathTex(
            r"x_i = 1 \text{ if transaction } i \text{ settles, } 0 \text{ otherwise}",
            font_size=34,
            color=WHITE,
        ).move_to(UP * 0.8)

        objective = MathTex(r"\max \sum_i v_i x_i", font_size=42, color=GREEN)
        objective.move_to(DOWN * 0.1)

        objective_text = Text(
            "maximize the total settled value",
            font_size=24,
            color=GREEN,
        ).next_to(objective, DOWN, buff=0.2)

        constraint = MathTex(
            r"\sum_i c_i x_i \leq \text{available cash}",
            font_size=38,
            color=BLUE,
        ).move_to(DOWN * 1.4)

        constraint_text = Text(
            "do not spend more cash than available",
            font_size=24,
            color=BLUE,
        ).next_to(constraint, DOWN, buff=0.15)

        self.play(Transform(title, formulation_title))
        self.play(FadeIn(intro))
        self.play(Write(variable))
        self.play(Write(objective), FadeIn(objective_text))
        self.play(Write(constraint), FadeIn(constraint_text))
        self.wait(3)

        self.play(
            FadeOut(intro),
            FadeOut(variable),
            FadeOut(objective),
            FadeOut(objective_text),
            FadeOut(constraint),
            FadeOut(constraint_text),
        )

        # Solver intuition
        solver_title = Text("How do solvers search intelligently?", font_size=36, color=YELLOW).to_edge(UP)
        self.play(Transform(title, solver_title))

        huge_space = Text("Naive approach: try every possible solution.", font_size=30, color=RED)
        huge_space.move_to(UP * 1.4)

        impossible = Text(
            "But the number of possibilities can be enormous.",
            font_size=28,
            color=GRAY_B,
        ).next_to(huge_space, DOWN, buff=0.35)

        self.play(FadeIn(huge_space), FadeIn(impossible))
        self.wait(2)
        self.play(FadeOut(huge_space), FadeOut(impossible))

        # Search space
        grid = VGroup()
        rows, cols = 5, 9

        for _ in range(rows * cols):
            square = Square(
                side_length=0.42,
                stroke_color=WHITE,
                stroke_width=1,
                fill_color="#1a2140",
                fill_opacity=0.8,
            )
            grid.add(square)

        grid.arrange_in_grid(rows=rows, cols=cols, buff=0.08).move_to(DOWN * 0.2)

        search_label = Text("Search space", font_size=26, color=WHITE).next_to(grid, UP, buff=0.35)

        self.play(FadeIn(search_label), LaggedStart(*[FadeIn(s) for s in grid], lag_ratio=0.01))
        self.wait(1)

        prune_text = Text(
            "1. Remove regions that cannot contain the best solution",
            font_size=27,
            color=YELLOW,
        ).to_edge(DOWN)

        self.play(FadeIn(prune_text))

        random.seed(7)
        indices = list(range(len(grid)))
        random.shuffle(indices)

        bad_indices = indices[:18]
        bad_regions = VGroup(*[grid[i] for i in bad_indices])

        self.play(
            bad_regions.animate.set_fill(RED, opacity=0.35).set_stroke(RED),
            run_time=1.2,
        )

        cross_lines = VGroup()
        for sq in bad_regions:
            cross_lines.add(Line(sq.get_corner(DL), sq.get_corner(UR), color=RED, stroke_width=2))
            cross_lines.add(Line(sq.get_corner(UL), sq.get_corner(DR), color=RED, stroke_width=2))

        self.play(Create(cross_lines), run_time=1)
        self.wait(1.5)

        remaining_regions = VGroup(*[grid[i] for i in indices[18:26]])

        keep_text = Text(
            "The solver focuses only on promising candidates.",
            font_size=26,
            color=GREEN,
        ).to_edge(DOWN)

        self.play(Transform(prune_text, keep_text))
        self.play(
            remaining_regions.animate.set_fill(GREEN, opacity=0.45).set_stroke(GREEN),
            run_time=1.1,
        )
        self.wait(2)

        self.play(FadeOut(prune_text), FadeOut(cross_lines), FadeOut(grid), FadeOut(search_label))

        # Relaxation
        relax_title = Text("2. Relax constraints to get optimistic bounds", font_size=34, color=YELLOW)
        relax_title.move_to(UP * 1.9)

        hard_problem = Text("Hard problem", font_size=32, color=WHITE)
        relaxed_problem = Text("Easier optimistic problem", font_size=32, color=GREEN)

        relaxed_arrow = Arrow(LEFT * 1.2, RIGHT * 1.2, color=YELLOW)

        relax_group = VGroup(hard_problem, relaxed_arrow, relaxed_problem).arrange(RIGHT, buff=0.5)
        relax_group.move_to(UP * 0.3)

        bound_text = Text(
            "If the optimistic version cannot beat the best solution found,\n"
            "we do not need to explore that region.",
            font_size=27,
            color=GRAY_B,
            line_spacing=1.1,
        ).to_edge(DOWN)

        self.play(FadeIn(relax_title))
        self.play(FadeIn(hard_problem), GrowArrow(relaxed_arrow), FadeIn(relaxed_problem))
        self.play(FadeIn(bound_text))
        self.wait(3)
        self.play(FadeOut(relax_title), FadeOut(relax_group), FadeOut(bound_text))

        # Decomposition
        structure_title = Text("3. Use the mathematical structure of the problem", font_size=34, color=YELLOW).to_edge(UP)
        self.play(Transform(title, structure_title))

        decomposition_label = Text("Example: decomposition", font_size=31, color=WHITE).move_to(UP * 1.75)

        main_box = RoundedRectangle(width=4.1, height=1.15, corner_radius=0.12,
                                    stroke_color=YELLOW, stroke_width=2.5,
                                    fill_color="#1a2140", fill_opacity=0.9)
        main_text = Text("Original large problem", font_size=23, color=YELLOW)
        main_problem = VGroup(main_box, main_text).move_to(UP * 0.75)

        subproblems = VGroup()
        for name in ["Subproblem A", "Subproblem B", "Subproblem C"]:
            box = RoundedRectangle(width=2.45, height=0.9, corner_radius=0.10,
                                   stroke_color=BLUE, stroke_width=2,
                                   fill_color="#111832", fill_opacity=0.9)
            txt = Text(name, font_size=19, color=BLUE)
            subproblems.add(VGroup(box, txt))

        subproblems.arrange(RIGHT, buff=0.55).move_to(DOWN * 0.65)

        arrows_down = VGroup()
        for sp in subproblems:
            arrows_down.add(
                Arrow(main_problem.get_bottom(), sp.get_top(), buff=0.12,
                      color=GRAY_B, stroke_width=3, max_tip_length_to_length_ratio=0.12)
            )

        reconstructed_box = RoundedRectangle(width=5.4, height=0.95, corner_radius=0.12,
                                             stroke_color=GREEN, stroke_width=2.5,
                                             fill_color="#112818", fill_opacity=0.9)
        reconstructed_text = Text("Reconstruct a feasible solution", font_size=23, color=GREEN)
        reconstructed = VGroup(reconstructed_box, reconstructed_text).move_to(DOWN * 2.1)

        arrows_reconstruct = VGroup()
        for sp in subproblems:
            arrows_reconstruct.add(
                Arrow(sp.get_bottom(), reconstructed.get_top(), buff=0.12,
                      color=GREEN, stroke_width=3, max_tip_length_to_length_ratio=0.12)
            )

        decomposition_caption = Text(
            "We may split a huge problem into smaller pieces,\n"
            "solve or analyze them separately,\n"
            "then combine them into a feasible solution for the original problem.",
            font_size=25,
            color=GRAY_B,
            line_spacing=1.1,
        ).to_edge(DOWN)

        self.play(FadeIn(decomposition_label))
        self.play(FadeIn(main_problem))
        self.play(LaggedStart(*[GrowArrow(a) for a in arrows_down], lag_ratio=0.15))
        self.play(LaggedStart(*[FadeIn(sp, shift=UP) for sp in subproblems], lag_ratio=0.15))
        self.play(LaggedStart(*[GrowArrow(a) for a in arrows_reconstruct], lag_ratio=0.15))
        self.play(FadeIn(reconstructed))
        self.play(FadeIn(decomposition_caption))
        self.wait(3.5)

        self.play(
            FadeOut(decomposition_label),
            FadeOut(main_problem),
            FadeOut(subproblems),
            FadeOut(arrows_down),
            FadeOut(arrows_reconstruct),
            FadeOut(reconstructed),
            FadeOut(decomposition_caption),
        )

        # MILP
        milp_label = Text("Example: linear structure and MILP solvers", font_size=32, color=WHITE)
        milp_label.move_to(UP * 1.75)

        milp_main = Text(
            "If the objective and constraints can be written in a linear way,\n"
            "we can use powerful commercial optimization solvers.",
            font_size=28,
            color=WHITE,
            line_spacing=1.1,
        ).move_to(UP * 0.45)

        milp_name = Text("MILP = Mixed-Integer Linear Programming", font_size=30, color=YELLOW)
        milp_name.move_to(DOWN * 0.65)

        solver_names = VGroup(
            Text("Gurobi", font_size=26, color=GREEN),
            Text("CPLEX", font_size=26, color=GREEN),
            Text("Xpress", font_size=26, color=GREEN),
            Text("SCIP", font_size=26, color=GREEN),
        ).arrange(RIGHT, buff=0.55).move_to(DOWN * 1.55)

        milp_caption = Text(
            "These solvers combine decades of research:\n"
            "bounds, cuts, branching, heuristics, and numerical linear algebra.",
            font_size=25,
            color=GRAY_B,
            line_spacing=1.1,
        ).to_edge(DOWN)

        self.play(FadeIn(milp_label))
        self.play(Write(milp_main))
        self.play(FadeIn(milp_name))
        self.play(LaggedStart(*[FadeIn(s, shift=UP) for s in solver_names], lag_ratio=0.15))
        self.play(FadeIn(milp_caption))
        self.wait(3.5)

        self.play(FadeOut(milp_label), FadeOut(milp_main), FadeOut(milp_name), FadeOut(solver_names), FadeOut(milp_caption))

        # Practical reality
        practical_title = Text("What happens in practice?", font_size=36, color=YELLOW).to_edge(UP)
        self.play(Transform(title, practical_title))

        target = Text(
            "For hard real-world problems,\n"
            "finding the true optimum may be too expensive.",
            font_size=32,
            color=WHITE,
            line_spacing=1.15,
        ).move_to(UP * 1.1)

        good_solution = Text(
            "So in practice, we often aim for a very good solution\n"
            "found quickly enough to be useful.",
            font_size=32,
            color=YELLOW,
            line_spacing=1.15,
        ).move_to(DOWN * 0.45)

        self.play(Write(target))
        self.wait(1.5)
        self.play(FadeIn(good_solution))
        self.wait(4)

        self.play(FadeOut(target), FadeOut(good_solution))

        # Final message
        final_title = Text("In short", font_size=38, color=YELLOW).to_edge(UP)
        self.play(Transform(title, final_title))

        final = Text(
            "Optimization is not brute force.\n"
            "It combines mathematics, algorithms,\n"
            "and problem structure to find good decisions efficiently.",
            font_size=34,
            color=WHITE,
            line_spacing=1.15,
        ).move_to(ORIGIN)

        self.play(Write(final))
        self.wait(3)

        end = Text("That is why formulation matters.", font_size=36, color=YELLOW).to_edge(DOWN)

        self.play(FadeIn(end))
        self.wait(3)
