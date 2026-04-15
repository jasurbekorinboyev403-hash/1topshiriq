// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StudentGPA {
    struct Student {
        string name;
        uint256 totalCredits;
        uint256 totalWeightedGrade;
        bool exists;
    }

    mapping(address => Student) private students;

    event StudentRegistered(address indexed student, string name);
    event CourseGradeAdded(address indexed student, uint256 credits, uint256 grade);

    function registerStudent(string calldata name) external {
        require(bytes(name).length > 0, "Name required");
        students[msg.sender] = Student(name, 0, 0, true);
        emit StudentRegistered(msg.sender, name);
    }

    function addCourseGrade(uint256 credits, uint256 grade) external {
        require(credits > 0, "Credits must be > 0");
        require(grade <= 100, "Grade must be 0-100");
        Student storage student = students[msg.sender];
        require(student.exists, "Register student first");

        student.totalCredits += credits;
        student.totalWeightedGrade += credits * grade;
        emit CourseGradeAdded(msg.sender, credits, grade);
    }

    function getMyGPA() external view returns (string memory name, uint256 totalCredits, uint256 gpaTimes100) {
        return getStudentGPA(msg.sender);
    }

    function getStudentGPA(address studentAddress) public view returns (string memory name, uint256 totalCredits, uint256 gpaTimes100) {
        Student storage student = students[studentAddress];
        require(student.exists, "Student not found");

        name = student.name;
        totalCredits = student.totalCredits;
        if (student.totalCredits == 0) {
            gpaTimes100 = 0;
        } else {
            gpaTimes100 = student.totalWeightedGrade * 100 / student.totalCredits;
        }
    }
}
