const String getProjectsQuery = r'''
  query GetProjects {
    projects {
      projectID
      projectName
      description
      startDate
      endDate
      createdBy
    }
  }
''';

// NEW: Query to get projects for a specific user
const String getProjectsByUserIdQuery = r'''
  query GetProjectsByUserId($userId: Int!) {
    projectsByUserId(userId: $userId) {
      projectID
      projectName
      description
      startDate
      endDate
    }
  }
''';

const String getUsersQuery = r'''
  query GetUsers {
    users {
      userID
      firstName
      lastName
      email
      role
      isActive
    }
  }
''';

const String getUsersForDropdownQuery = r'''
  query GetUsersForDropdown {
    users {
      userID
      firstName
      lastName
    }
  }
''';

const String createProjectMutation = r'''
  mutation CreateProject($input: ProjectInput!) {
    createProject(input: $input)
  }
''';

const String getTasksByProjectIdQuery = r'''
  query GetTasksByProjectId($projectId: Int!) {
    tasksByProjectId(projectId: $projectId) {
      taskID
      taskName
      description
      status
      priority
      dueDate
    }
  }
''';

const String createTaskMutation = r'''
  mutation CreateTask($input: TaskInput!) {
    createTask(input: $input)
  }
''';

const String getTasksQuery = r'''
  query GetTasks {
    tasks { taskID, status }
  }
''';

const String getDashboardStatsQuery = r'''
  query GetDashboardStats {
    projects { projectID }
    tasks { status }
    users { userID }
  }
''';

const String deleteTaskMutation = r'''
  mutation DeleteTask($id: Int!) { deleteTask(id: $id) }
''';
// NEW: Query for the stats dashboard

