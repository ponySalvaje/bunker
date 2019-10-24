module Api 
  module V1 
    class SpacesController < ApplicationController

      before_action :authenticate_user!

        # GET /spaces
      def index
        @spaces = Space.all
        render json: @spaces,status: :ok

        rescue ActiveRecord::RecordNotFound
            render json: [],status: :not_found
      end

      def lessors
        @spaces = Lessor.find(params[:id]).spaces
        render json: @spaces,status: :ok

        rescue ActiveRecord::RecordNotFound
            render json: [],status: :not_found
      end

      def first_photo
        @space = Space.find(params[:id])
        render json: @space.photos.first, status: :ok

        rescue ActiveRecord::RecordNotFound
            render json: [],status: :not_found
      end

      def info
        @space = Space.find(params[:id])
        @location = @space.location

        @spaceInfo = SpaceInfo.new(
          id: @space.id,
          status: @space.status, 
          rent_price: @space.rent_price,
          space_type: @space.space_type, 
          description: @space.description, 
          title: @space.title,
          address: @location.address,
          first_photo: @space.photos.first.photo_url
        )

        if @spaceInfo != nil 
            render json: @spaceInfo, status: :ok
        end 

        rescue ActiveRecord::RecordNotFound
          render json: [],status: :not_found
      end

      def info_lessors
        @spaces = Lessor.find(params[:id]).spaces
        @spacesInfo = Array.new

        @spaces.each do |space|
          @space = Space.find(space.id)

          @spaceInfo = SpaceInfo.new(
            id: @space.id,
            status: @space.status, 
            rent_price: @space.rent_price,
            space_type: @space.space_type, 
            description: @space.description, 
            title: @space.title,
            address: @space.location.address,
            first_photo: @space.photos.first.photo_url
          )
          @spacesInfo.push @spaceInfo
        end

        if @spacesInfo != nil 
            render json: @spacesInfo, status: :ok
        end 

      rescue ActiveRecord::RecordNotFound
        render json: [],status: :not_found
      end

      def info_around
        @spaces = Spaces.all
        @spacesInfo = Array.new

        @spaces.each do |space|
          @space = Space.find(space.id)

          @spaceInfo = SpaceInfo.new(
            id: @space.id,
            status: @space.status, 
            rent_price: @space.rent_price,
            space_type: @space.space_type, 
            description: @space.description, 
            title: @space.title,
            address: @space.location.address,
            first_photo: @space.photos.first.photo_url
          )
          @spacesInfo.push @spaceInfo
        end

        if @spacesInfo != nil 
            render json: @spacesInfo, status: :ok
        end 

      rescue ActiveRecord::RecordNotFound
        render json: [],status: :not_found
      end

      # GET /spaces/1
      def show
        @space = Space.find(params[:id])
        if @space != nil 
            render json: @space, status: :ok
        end 

        rescue ActiveRecord::RecordNotFound
            render json: [],status: :not_found
      end

      # POST /spaces
      def create
        @lessor = Lessor.find(params[:lessor][:id])

        @space = Space.new(
          lessor_id: @lessor.id, 
          status: params[:status], 
          width: params[:width], 
          height: params[:height], 
          area: params[:area], 
          rent_price: params[:rent_price], 
          space_type: params[:space_type],
          description: params[:description]
          )
        if @space.save
            render json: @space, adapter: :attributes, status: :created
        end

        rescue ActiveRecord::RecordInvalid
            render json: [],status: :unprocessable_entity

        rescue ActionController::ParameterMissing
            render json: [],status: :bad_request
        
        rescue ActiveRecord::RecordNotFound
            render json: [],status: :not_found
      end

      # PATCH/PUT /spaces/1
      def update
        @lessor = Lessor.find(params[:lessor][:id])
        @space = Space.find(params[:id])
        if @space.update(
          lessor_id: @lessor.id, 
          status: params[:status], 
          width: params[:width], 
          height: params[:height], 
          area: params[:area], 
          rent_price: params[:rent_price], 
          space_type: params[:space_type],
          description: params[:description]
          )
            render json: @space, status: :ok
        end

        rescue ActiveRecord::RecordNotFound
            render json: [], status: :not_found

        rescue ActionController::ParameterMissing
            render json: [], status: :bad_request
      end

      # DELETE /spaces/1
      def destroy
        @space = Space.find(params[:id])
        if @space.destroy
            render json: @space, status: :ok
        end

        rescue ActiveRecord::RecordInvalid
            render json: [],status: :not_found
      end

      # POST /spaces/complete
      def create_complete
        @lessor = Lessor.find(params[:lessor][:id])

        @space = Space.new(
          lessor_id: @lessor.id, 
          status: 0,
          width: params[:width], 
          height: params[:height], 
          area: params[:area], 
          rent_price: params[:rent_price], 
          space_type: params[:space_type],
          description: params[:description],
          title: params[:title]
          )
        if @space.save
          @location = Location.new(
            space_id: @space.id,
            address: params[:location][:address],
            latitude: params[:location][:latitude],
            longitude: params[:location][:longitude]
          )
          if @location.save
            @servicesFromSpace = Array.new(params[:services])
            @servicesFromSpace.each do |serviceFromSpace|
              @serviceSpaceDetail = SpaceServiceDetail.new(
                space_id: @space.id,
                service_id: serviceFromSpace[:id]
              )
              if @serviceSpaceDetail.save
              end
            end
            @photosFromSpace = Array.new(params[:photos])
            @photosFromSpace.each do |photoFromSpace|
              @photo = Photo.new(
                space_id: @space.id,
                photo_url: photoFromSpace[:photo_url]
              )
              if @photo.save
              end
            end
            render json: @space, adapter: :attributes, status: :created
          end
        end

        rescue ActiveRecord::RecordInvalid
          render json: [],status: :not_found
      end

      private
      def space_params
        params.require(:space).permit(
          :status,
          :width,
          :height,
          :area,
          :rent_price,
          :space_type,
          :description,
          :title,
          :photos,
          :services,
          location: [:address, :latitude, :longitude],
          photos: [:photo_url],
          lessor: [:id, :user_id, :ruc, :commercial_name, :first_name, :last_name, :doc_type, :doc_number, :phone, :email, :created_at, :updated_at]
        )
      end

    end
  end
end
