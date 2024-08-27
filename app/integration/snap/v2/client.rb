require "graphql/client"
require "graphql/client/http"

module Snap
  module V2
    module Client
      HTTP = GraphQL::Client::HTTP.new("https://manage-api.snap.app/") do
        def headers(context)
          { "manage_organization_id": context[:id] }
        end
      end

      Schema = GraphQL::Client.load_schema(HTTP)

      Client = GraphQL::Client.new(schema: Schema, execute: HTTP)
      Query = Client.parse <<~'GRAPHQL'
        query {
          manageOrganization {
            webFolder
            dbFolder
            path
            schoolId
            linkSchoolId
            lKschoolId
            adReport
            schoolName
            sqlBase
            lat
            long
            address
            city
            state
            zip
            phone
            fax
            stateOrg
            iCon
            mascot
            ad
            principal
            logo
            siteType
            webSite
            featured
            show
            message
            adSchool
            feederTowns
            signUpCode
            color1
            color2
            massUpdate
            registrationPolicy
            campRegConfirmationTxt
            sportRegConfirmationTxt
            registrationEmail
            registrationType
            registrationEnabled
            emailBlastEnabled
            staffCalendarEnabled
            showTeamPagesFirst
            autoApproveScoreOnly
            webPassword
            oldSchoolId
            psSchoolId
            psStoreActive
            masterSchoolId
            hasMigratedFromAccessToSqlServer
            hasAotm
            hasRegistration
            hasActivities
            hasAthletics
            aotmSpotlight
            emailSpotlight
            gallerySpotlight
            hasEmailBlast
            motto
            facebookUrl
            hasFacebookUrl
            twitterUrl
            hasTwitterUrl
            instagramUrl
            hasInstagramUrl
            showSchoolNameAndMotto
            equipmentEnabled
            customLabel
            customLink
            customLabel2
            customLink2
            timeZone
            adProgramID
            showAd
            conferenceName
            conferenceURL
            ncesId
            registrationUrl
            schoolWebsiteUrl
            fuelMyClubLink
            programsForOrganization {
              count
              list {
                id
                sportCode
                sportName
                sportSegment
                sportDescription
                gender
                genderSegment
                level1
                levelName
                levelSegment
                homeField
                groupVal
                isDeleted
                seasonYearsForProgram
                seasonsForProgram(
                  filter: { where: { year: "2024-2025", isDeleted: false } }
                ) {
                  count
                  list {
                    seasonId
                    sportCode
                    year
                    season
                    homeField
                    preview
                    webPassword
                    budget
                    defaultTimeForPractice
                    defaultTimeForEvent
                    isDeleted
                    eventsForSeason(
                      filter: {
                        whereNot: { eventDate: null }
                        where: { gs: ["G", "T", "S"] }
                      }
                    ) {
                      count
                      list {
                        eventId
                        years
                        endTime
                        place
                        seasonTeam
                        activity
                        eventDate
                        location
                        opponentCode
                        opponent
                        transportation
                        transId
                        confirmed
                        rollover
                        gs
                        startTime
                        busTime
                        conference
                        contract
                        numBuses
                        comments
                        tournament
                        fee
                        results
                        lead
                        title
                        headline
                        picture
                        promote
                        directions
                        webDir
                        conferenceId
                        prepSetup
                        impactEvent
                        busFee
                        revenue
                        gateRevenue
                        winPoints
                        lossPoints
                        earlyDismissalRequired
                        earlyDismissalTime
                        estimatedReturnTime
                        departureLocation
                        transportComments
                        conferenceEventId
                        cancellationStatus
                        existsInMls
                        createdAt
                        updatedAt
                        gender
                        eventType
                        directionLink
                        teamName
                        eventDetailsPath
                        eventDay
                        groupVal
                        season
                        sortStartTime
                        eventResultID
                        outcome
                        teamScore
                        opponentScore
                        eventComplete
                        showFrontPage
                        reportScore
                        reportStory
                        eventStory
                        eventLead
                        eventTitle
                        author
                        isApproved
                        updateResultDate
                        createdResultAt
                        updatedResultAt
                        createdResultBy
                        updatedResultBy
                        eventDateTime
                        level
                        eventResults {
                          id
                          event_id
                          school_id
                          outcome
                          score
                          opponent_score
                          event_complete
                          on_front_page
                          report_score
                          report_story
                          event_story
                          event_lead
                          event_title
                          event_date
                          author
                          is_approved
                          created_at
                          updated_at
                          created_by
                          updated_by
                        }
                      }
                    }
                    coachForSeason {
                      count
                      list {
                        coachId
                        adId
                        schoolId
                        seasonId
                        firstName
                        lastName
                        title
                        summary
                        headCoach
                        isApproved
                        photoId
                        createdAt
                        updatedAt
                        createdBy
                        updatedBy
                      }
                    }
                    playersForSeason(filter: { where: null }) {
                      count
                      list {
                        jersey
                        fName
                        lName
                        position
                        height
                        weight
                        gradYear
                        participantId
                        sortJersey
                        rosterId
                        schoolId
                        seasonId
                        feePaid
                        permission
                        physical
                        ch1
                        ch2
                        ch3
                        status
                        gender
                        dob
                        studentId
                        stAddress
                        city
                        state
                        zip
                        homePhone
                        dayPhone
                        physicalDate
                        custodyCode
                        livesWithCode
                        noPress
                        physician
                        physicianTelephone
                        insuranceCompany
                        insurancePolicyNum
                        preferredHospital
                        hospitalPhone
                        shirtsize
                        shortsize
                        hatsize
                      }
                    }
                  }
                }
                photosForPrograms {
                  count
                  list {
                    id
                    image
                    filename
                    companyId
                    projectId
                    src
                    school
                    sport
                    caption
                    title
                    group
                    rphoto
                    level
                    batch
                    needsApproval
                    recordStatus
                    layout
                    createdAt
                    updatedAt
                    createdBy
                    updatedBy
                  }
                }
              }
            }
          }
        }
      GRAPHQL

      def self.import(id)
        r = Client.query(Query, context: { id: id })
        s = r.data.manage_organization

        existing_school = School.find_by(id: "snap2-#{s.school_id}")
        custom_players = {}
        admin_ids = existing_school.try(:admin_ids)

        if existing_school
          existing_school.teams.map do |team|
            team.pressbox_posts.destroy_all
            team.images.destroy_all
            custom_team_players = team.players.where(custom: true)
            if custom_team_players.count.positive?
              custom_players[team.id] = custom_team_players.pluck(:id)
              custom_team_players.update_all(team_id: nil)
            end
            team.players.reload.destroy_all

            team.events.each do |event|
              event.team_results.destroy_all
              event.team_events.destroy_all
              event.result.try(:destroy)
              event_location = event.location
              event.destroy
              event_location&.destroy
            end

            team.destroy
          end

          existing_school.destroy
        end
        Location.find_by(id: "snap2-#{s.school_id}")&.destroy

        location = Location.new(
          id: "snap2-#{s.school_id}",
          name: s.school_name,
          address_1: s.address,
          city: s.city,
          state: s.state,
          zip: s.zip,
          latitude: s.lat,
          longitude: s.long
        )

        location.geocode

        begin
          location.timezone = Timezone.lookup(location.latitude, location.longitude).name
        rescue StandardError
          location.timezone = Timezone["America/New_York"].name
        end

        seasons = Season.all

        school = School.new(
          id: "snap2-#{s.school_id}",
          name: s.school_name,
          mascot: s.mascot,
          is_vnn: false,
          url: "https://schools.snap.app/#{s.path}",
          primary_color: s.color1,
          secondary_color: s.color2,
          logo_url: "https://8to18-logos.s3.amazonaws.com/images/#{s.state.downcase}-#{s.path.downcase}.png",
          facebook_url: s.facebook_url,
          twitter_url: s.twitter_url,
          instagram_url: s.instagram_url,
          phone: s.phone,
          visible: true,
          location: location,
          teams: s.programs_for_organization.list.map do |program|
                   season = program.seasons_for_program.list[0]
                   next unless season

                   gender_record = Gender.find_by("name LIKE ?", "#{program.gender}%")
                   level_record = Level.find_by("name LIKE ?", "#{program.level_name.chars.first}%")
                   sport_record = Sport.find_by(name: program.sport_name) || Sport.create(
                     id: Time.now.to_f.to_s.gsub(".", ""), name: program.sport_name
                   )
                   name = [gender_record, level_record, sport_record].compact.join(" ")

                   year_record = Year.find_by(name: season.year.gsub("-", "/"))
                   season_record = seasons.select do |se|
                     season.season&.include?(se.name)
                   end.first || Sport.find_by(name: program.sport_name.split.first).try(:season) || sport_record.season || Season.find_by(name: "Year-round")

                   Team.new(
                     id: "snap2-#{s.school_id}-#{season.season_id}",
                     name: name,
                     year: year_record,
                     season: season_record,
                     level: level_record,
                     gender: gender_record,
                     sport: sport_record,
                     players: season.players_for_season.list.map do |player|
                       Player.new(
                         first_name: player.f_name,
                         last_name: player.l_name,
                         grad_year: player.grad_year,
                         jersey: player.jersey,
                         position: player.position,
                         height: player.height.to_s.gsub(/[^1-9]/, "").present? ? player.height : "",
                         weight: player.weight
                       )
                     end,
                     images: program.photos_for_programs.list.map do |photo|
                       Image.new(
                         id: "snap2-#{s.school_id}-#{photo.id}",
                         description: photo.filename,
                         url: photo.src
                       )
                     end,
                     team_events: season.events_for_season.list.map do |event|
                       school_location = location
                       home = event.place == "H"

                       location_search = home && school_location ? "#{event.location} #{school_location.city}" : event.location
                       location_results = if event.location.present?
                                            Geocoder.search(location_search,
                                                            locationbias: "point:#{school_location.latitude},#{school_location.longitude}")
                                          else
                                            []
                                          end
                       location_results = location_results.select do |result|
                         school_location.distance_to(result.coordinates) < 75
                       end
                       location_result = location_results.min_by do |result|
                         school_location.distance_to(result.coordinates)
                       end

                       timezone = Timezone["America/New_York"]

                       if location_result && location_result.place_id
                         location_place = Geocoder.search(location_result.place_id,
                                                          lookup: :google_places_details).first
                         begin
                           timezone = Timezone.lookup(location_place.latitude, location_place.longitude)
                         rescue StandardError => e
                           timezone = Timezone["America/New_York"]
                         end
                         if location_place && location_place.street_address.present?
                           new_location_record = Location.new(
                             id: "snap2-#{s.school_id}-#{season.season_id}-#{event.event_id}",
                             name: event.location,
                             address_1: location_place.street_address,
                             city: location_place.city,
                             state: location_place.state,
                             zip: location_place.postal_code,
                             latitude: location_place.latitude,
                             longitude: location_place.longitude,
                             timezone: timezone.name
                           )
                         end
                       else
                         unless event.location.present?
                           new_location_record = Location.new(
                             id: "snap2-#{s.school_id}-#{season.season_id}-#{event.event_id}",
                             name: school_location.name,
                             address_1: school_location.address_1,
                             address_2: school_location.address_2,
                             city: school_location.city,
                             state: school_location.state,
                             zip: school_location.zip,
                             latitude: school_location.latitude,
                             longitude: school_location.longitude,
                             timezone: timezone.name
                           )
                         end
                       end

                       begin
                         start = DateTime.strptime("#{event.event_date} #{event.start_time} #{timezone.utc_offset / 60 / 60}",
                                                   "%m/%d/%Y %l:%M %p %z")
                       rescue ArgumentError => e
                         tba = true
                         begin
                           start = DateTime.strptime("#{event.event_date} #{timezone.utc_offset / 60 / 60}",
                                                     "%m/%d/%Y %z")
                         rescue ArgumentError => e
                         end
                       end

                       result = event.event_results&.find { |er| er.score.present? }

                       has_result = result&.score&.match(/^(\d)+$/) && result.opponent_score.match(/^(\d)+$/)
                       has_team_result = result&.score&.include?("Place")
                       has_post = result && result.event_story.present?

                       TeamEvent.new(home: home, opponent_name: event.opponent, event:
                        Event.new(
                          id: "snap2-#{s.school_id}-#{season.season_id}-#{event.event_id}",
                          name: event.activity || event.opponent,
                          event_type: event.event_type.try(:downcase),
                          start: start,
                          tba: tba,
                          conference: event.conference == "Y",
                          scrimmage: event.activity.try(:include?, "Scrimmage"),
                          canceled: event.cancellation_status == "1",
                          location: new_location_record,
                          location_name: event.location,
                          team_events: [],
                          result: if has_result
                                    Result.new(home: home ? result.score : result.opponent_score,
                                               away: home ? result.opponent_score : result.score)
                                  end,
                          team_results: if has_team_result
                                          [
                                            TeamResult.new(team_id: "snap2-#{s.school_id}-#{season.season_id}",
                                                           place: result.score.gsub(/\D/,
                                                                                    ""))
                                          ]
                                        else
                                          []
                                        end,
                          pressbox_posts: if has_post
                                            [
                                              PressboxPost.new(
                                                id: "snap2-#{s.school_id}-#{season.season_id}-#{event.event_id}",
                                                team_id: "snap2-#{s.school_id}-#{season.season_id}",
                                                title: event.activity || event.opponent,
                                                recap: { Summary: result.event_story }.to_json,
                                                created: start,
                                                is_visible: true
                                              )
                                            ]
                                          else
                                            []
                                          end
                        ))
                     end
                   )
                 end.compact
        )

        school.save

        school.update(admin_ids: admin_ids)
        custom_players.each do |team_id, players_ids|
          Player.where(id: players_ids).update_all(team_id: team_id)
        end
      end
    end
  end
end
