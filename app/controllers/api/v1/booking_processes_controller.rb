module Api 
    module V1 
        class BookingProcessesController < ApplicationController

            before_action :authenticate_user!


            #GET /booking_processes
            def index
                @booking_processes = BookingProcess.all
                render json: @booking_processes, status: :ok

                rescue ActiveRecord::RecordNotFound
                    render json: [],status: :not_found
            end

            #GET /booking_processes/1
            def show
                @booking_process = BookingProcess.find(params[:id]) 
                if @booking_process != nil
                    render json: @booking_process, status: :ok
                end

                rescue ActiveRecord::RecordNotFound
                    render json: [],status: :not_found
            end


            #POST /booking_process
            def create
                @lessor = Lessor.find(params[:lessor][:id])
                @space = Space.find(params[:space][:id])
                @document = Document.find(params[:document][:id])

                @booking_process = BookingProcess.new(
                    lessor_id: @lessor.id,
                    space_id: @space.id,
                    document_id: @document.id,
                    step: params[:step],
                    start_date: params[:start_date],
                    end_date: [:end_date],
                    monthly_fee: [:monthly_fee],
                    )

                if @booking_process.save
                    render json: @booking_process, adapter: :attributes, status: :created
                end

                rescue ActiveRecord::RecordInvalid
                    render json: [],status: :unprocessable_entity
                
                rescue ActiveController::ParameterMissing
                    render json: [],status: :bad_request
                rescue ActiveRecord::RecordNotFound
                    render json: [],status: :not_found
            end
            

            #PATCH/PUT /booking_process/1
            def update
                @booking_process=BookingProcess.find(params[:id])
                if @booking_process.update(booking_process_params)
                    render json: @booking_process, status: :ok
                end

                rescue ActiveRecord::RecordNotFound
                    render json: [], status: :not_found
                
                rescue ActiveController::ParameterMissing
                    render json: [], status: :bad_request
            end


            #DELETE /booking_process/1
            def destroy
                @booking_process = BookingProcess.find(params[:id])
                if @booking_process.destroy
                    render json: @booking_process, status: :ok
                end

                rescue ActiveRecord::RecordInvalid
                    render json: [],status: :not_found
            end
                

            private
            def booking_process_params
                params.require(:booking_process).permit(
                    :step,
                    :start_date,
                    :end_date,
                    :monthly_fee,
                    :lessor_id,
                    :space_id,
                    :document_id,
                    lessor: [:id, :first_name, :last_name, :doc_type, :doc_number, :phone, :email, :type],
                    space: [:id, :status, :width, :height, :area, lessee: [:id, :ruc, :commercial_name, :first_name, :last_name, :doc_type, :doc_number, :phone, :email]],
                    document: [:id, :url_document, :document_type_id]
                )
            end
                
        end
    end
end
