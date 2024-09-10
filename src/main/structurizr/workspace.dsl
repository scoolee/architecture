workspace {
    
    !identifiers hierarchical
    
    model {
        systemAdmin = person "System Admin" "Administers system functions"
        manager = person "Manager" "Manages school"
        teacher = person "Teacher" "Teaches a subject at school"
        student = person "Student" "Attends school clases"
        parent = person "Parent" "Legal guardian of student"
    
        scoolee = softwareSystem "Scoolee" "Internet system that connects teachers, students and their parents"

        systemAdmin -> scoolee
        manager -> scoolee
        teacher -> scoolee
        student -> scoolee
        parent -> scoolee
    }
    
    views {

        systemLandscape "System" {
            include *
        }

        container scoolee "Containers_All" {
            include *
            autolayout
        }

        styles {
            element "Person" {
                shape Person
            }
            element "API" {
                shape hexagon
            }
            element "DB" {
                shape cylinder
            }
            element "Topic" {
                shape Pipe
            }
            
        }

    }

}