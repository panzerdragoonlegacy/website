module QuizzesHelper
  # Returns true if the specified quiz_answer is the user's chosen answer.
  def chosen_answer(quiz_question, quiz_answer)
    if params[:results]
      if params[:results][quiz_question.id.to_s] == quiz_answer.id.to_s
        return true
      end
    end
  end

  # Returns the user's quiz score.
  def score
    score = 0
    params[:results].each do |key, value|
      quiz_answer = QuizAnswer.find(value)
      score = score + 1 if quiz_answer.correct_answer?
    end
    score
  end
end
