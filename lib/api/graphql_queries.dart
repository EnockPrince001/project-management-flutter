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
