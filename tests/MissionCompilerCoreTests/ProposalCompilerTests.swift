import MissionCompilerCore
import XCTest

final class ProposalCompilerTests: XCTestCase {
    private let compiler = ProposalCompiler()

    func testEmptyPromptIsRejected() {
        XCTAssertThrowsError(try compiler.compile(TaskDraft(rawPrompt: "  \n "))) { error in
            XCTAssertEqual(error as? ProposalCompilerError, .emptyPrompt)
        }
    }

    func testOriginalGoalAndConstraintsArePreserved() throws {
        let proposal = try compiler.compile(
            TaskDraft(
                rawPrompt: "修复空数组崩溃",
                constraints: "不要增加依赖"
            )
        )

        XCTAssertEqual(proposal.goal, "修复空数组崩溃")
        XCTAssertTrue(proposal.protections.contains("用户不可变条件：不要增加依赖"))
    }

    func testPublicPreviewFailsSafe() throws {
        let proposal = try compiler.compile(TaskDraft(rawPrompt: "增加一个小功能"))

        XCTAssertEqual(proposal.mode, .plan)
        XCTAssertEqual(proposal.riskLevel, .yellow)
        XCTAssertTrue(proposal.capabilities.contains("Codex App Server（下一里程碑接入）"))
        XCTAssertTrue(proposal.rollback.contains("不会修改项目"))
    }

    func testLongTitleIsTruncated() throws {
        let prompt = String(repeating: "任务", count: 20)
        let proposal = try compiler.compile(TaskDraft(rawPrompt: prompt))

        XCTAssertTrue(proposal.title.hasSuffix("…"))
        XCTAssertLessThanOrEqual(proposal.title.count, 27)
    }
}
