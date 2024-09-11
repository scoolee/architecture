workspace {
    
    !identifiers hierarchical
    
    model {
        systemAdmin = person "System Admin" "Administers system functions"
        manager = person "Manager" "Manages school"
        teacher = person "Teacher" "Teaches a subject at school"
        student = person "Student" "Attends school clases"
        parent = person "Parent" "Legal guardian of student"
    
        scoolee = softwareSystem "Scoolee" "Internet system that connects teachers, students and their parents" {

            ui = container "ui" "Scoolee Progressive Web Application running in user browser" Angular

            ui_server = container "ui-server" "Serves PWA files to user browser" SpringBoot WebApp

            api_gateway_service = group "API Gateway" {
                api_gateway = container "api-gateway" "Exposes REST API to the UI" SpringBoot API
            }

            authn_service = group "Authentication service" {
                authn_app = container "authn-app" "OpenID Connect provider" SpringBoot WebApp
                authn_db = container "authn-db" "Stores user accounts with credentials" Postgres DB
            }

            schools_service = group "Schools service"  {
                schools_api = container "schools-api" "Schools management API" SpringBoot API
                schools_db = container "schools-db" "Schools database" Postgres DB
                schools_topic = container "schools-topic" "School events topic" Kafka Topic
                teachers_topic = container "teachers-topic" "Teachers events topic" Kafka Topic
                students_topic = container "students-topic" "Students events topic" Kafka Topic
                parents_topic = container "parents-topic" "Parents events topic" Kafka Topic
                groups_topic = container "groups-topic" "Student groups events topic" Kafka Topic
                courses_topic = container "courses-topic" "Courses events topic" Kafka Topic

                schools_api -> schools_db
                schools_api -> schools_topic
                schools_api -> teachers_topic
                schools_api -> students_topic
                schools_api -> parents_topic
                schools_api -> groups_topic
                schools_api -> courses_topic
            }

            users_service = group "Users service" {
                users_api = container "users-api" "Manages user accounts" SpringBoot API
                users_db = container "users-db" "Users database" Postgres DB
                users_topic = container "users-topic" "User events" Kafka Topic

                users_api -> users_db "" JDBC
                users_api -> users_topic "User events"
            }

            messages_service = group "Messages service" {
                messages_api = container "messages-api" "API to exchange unicast, multicast and group messages exchange between users" SpringBoot API
                messages_db = container "messages-db" "Messages database" Cassandra DB
                messages_index = container "messages-idx" "Full test searching index" ElasticSearch DB
                messages_blob = container "messages-blob" "Attachements BLOB storage" Blob DB
                messages_topic = container "messages-topic" "Message events" Kafka Topic

                messages_api -> messages_db "stores/retrieves messages to/from"
                messages_api -> messages_index "indexes/serches messages with"
                messages_api -> messages_blob "stores attachments in"
                messages_api -> messages_topic "sends events to"
            }

            schedules_service = group "Schedules service" {
                schedules_api = container "schedules-api" "API to manage course schedules" SpringBoot API
                schedules_db = container "schedules-db" "Schedule database" Postgres DB
                schedules_topic = container "schedules-topic" "Schedule events" Kafka Topic

                schedules_api -> schedules_db
                schedules_api -> schedules_topic
            }

            grades_service = group "Grades service" {
                grades_api = container "grades-api" "API to manage grades" SpringBoot API
                grades_db = container "grades-db" "Grades database" Postgres DB
                grades_topic = container "grades-topic" "Grades topic" Kafka Topic

                grades_api -> grades_db
                grades_api -> grades_topic
            }

            teacher_substitutions_service = group "Teacher substitutions service" {
                teacher_substitutions_api = container "teacher-substitutions-api" "API to manage teacher substitutions" SpringBoot API
                teacher_substitutions_db = container "teacher-substitutions-db" "Teacher substitutions database" Postgres DB
                teacher_substitutions_topic = container "teacher-substitutions-topic" "Teacher substitutions events" Kafka Topic

                teacher_substitutions_api -> teacher_substitutions_db
                teacher_substitutions_api -> teacher_substitutions_topic
            }

            student_absences_service = group "Student absences service" {
                student_absences_api = container "student-absences-api" "API to manage student attendance" SpringBoot API
                student_absences_db = container "student-absences-db" "Student attendance DB" Cassandra DB
                student_absences_topic = container "student-absences-topic" "Student attendance events" Kafka Topic
            
                student_absences_api -> student_absences_db
                student_absences_api -> student_absences_topic
            }

            notification_service = group "Notification service" {
                notification_api = container "notification-api" "API to notify users" SpringBoot API
                notification_db = container "notification-db" "Notification settings database" Postgres DB
                notification_topic = container "notification-topic" "Notifications to deliver" Kafka Topic

                notification_api -> notification_db "Store/retrieve notification settings"
                notification_api -> notification_topic "Queues notifications to be delivered"
            }

            email_service = group "Email service" {
                email_api = container "email-api" "Sends e-mails to users" SpringBoot API
                email_db = container "email-db" "E-mail templates and address lists" Postgres DB

                email_api -> email_db "" JDBC
            }

            push_service = group "Push service" {
                push_api = container "push-api" "Sends Push notifications to users" SpringBoot API
                push_db = container "push-db" "Stores push configuration data" Postgres DB

                push_api -> push_db "" JDBC
            }

            audit_service = group "Audit service" {
                audit_api = container "audit-api" "API to search audit events" SpringBoot API
                audit_index = container "Audit-index" "Audit events index" ElasticSearch DB
            
                audit_api -> audit_index "Store / search audit events using"
            }


            systemAdmin -> ui "Manages system with" UI
            manager -> ui "Manages schools with" UI
            teacher -> ui "Manages grades, absences, substitutions, exchange messages with" UI
            student -> ui "Views schedule, grades, exchanges messages with" UI
            parent -> ui "Views schedule, grades, exchanges messages with" UI

            systemAdmin -> authn_app "Authenticate with" HTTPS
            manager -> authn_app "Authenticate with" HTTPS
            teacher -> authn_app "Authenticate with" HTTPS
            student -> authn_app "Authenticate with" HTTPS
            parent -> authn_app "Authenticate with" HTTPS

            ui -> authn_app "Request authentication from" "OIDC"

            ui -> api_gateway "Invokes API exposed by" REST

            api_gateway -> schools_api "" REST
            api_gateway -> users_api "" REST
            api_gateway -> schedules_api "" REST
            api_gateway -> messages_api "" REST
            api_gateway -> messages_blob "" HTTPS
            api_gateway -> notification_api "" REST
            api_gateway -> grades_api "" REST
            api_gateway -> teacher_substitutions_api "" REST
            api_gateway -> student_absences_api "" REST

            users_topic -> authn_app "User events" Kafka

            schools_topic -> notification_api
            teachers_topic -> notification_api
            students_topic -> notification_api
            parents_topic -> notification_api
            groups_topic -> notification_api
            courses_topic -> notification_api
            users_topic -> notification_api
            student_absences_topic -> notification_api
            grades_topic -> notification_api
            teacher_substitutions_topic -> notification_api
            messages_topic -> notification_api
            schedules_topic -> notification_api

            schools_topic -> audit_api
            teachers_topic -> audit_api
            students_topic -> audit_api
            parents_topic -> audit_api
            groups_topic -> audit_api
            courses_topic -> audit_api
            users_topic -> audit_api
            student_absences_topic -> audit_api
            grades_topic -> audit_api
            teacher_substitutions_topic -> audit_api
            messages_topic -> audit_api
            schedules_topic -> audit_api
            notification_topic -> email_api
            notification_topic -> push_api

            teachers_topic -> authn_app
            students_topic -> authn_app
            parents_topic -> authn_app
        }
    }
    
    views {

        systemContext "scoolee" {
            include *
            autoLayout
        }

        container scoolee "Containers_All" {
            include *
            exclude element.tag==DB
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